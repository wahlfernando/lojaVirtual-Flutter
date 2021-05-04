//gerenciador de carts;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:loja_virtual/models/address.dart';
import 'package:loja_virtual/models/cart_product.dart';
import 'package:loja_virtual/models/product.dart';
import 'package:loja_virtual/models/user.dart';
import 'package:loja_virtual/models/user_manager.dart';
import 'package:loja_virtual/services/cepaberto_services.dart';


class CartManager extends ChangeNotifier{

  List<CartProduct> items = [];
  User user;
  Address address;
  num productPrice = 0.0;
  num deliveryPrice;

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool value){
    _loading = value;
    notifyListeners();
  }


  num get totalPrice => productPrice + (deliveryPrice ?? 0);

  final Firestore firestore = Firestore.instance;

  //updateUser faz com que sempre que logar um usuário novo ele pegue as configurações daquele usuário se existir.
  void updateUser(UserManager userManager) {
    user = userManager.user;
    productPrice = 0.0;
    removeAddress();
    items.clear();

    if (user != null) {
      _loadCartItems();
      _loadUserAddress();
    }
  }

  Future<void> _loadCartItems() async {
    final QuerySnapshot cartSnap = await user.cartReference.getDocuments();
    items = cartSnap.documents.map(
            (d) => CartProduct.fromDocument(d)..addListener(_onItemUpdated)
    ).toList();
  }

  Future<void> _loadUserAddress() async{
    if(user.address != null && await calculateDelivery(user.address.lat, user.address.long)){
      address = user.address;
      notifyListeners();
    }
  }

  void addToCart(Product product) {
    try {
      //aqui ele verifica se ja tem um produto com os mesmos tamanhos e id
      final e = items.firstWhere((p) => p.stackable(product));
      e.increment();
    } catch (e) {
      //caso não tenha, ele vai adicionar um novo cart.
      final cartProduct = CartProduct.fromProduct(product);
      cartProduct.addListener(_onItemUpdated);
      items.add(cartProduct);
      //user.cartReference.add(cartProduct.toCartItemMap()) ==> cria um documento com um id aleatério no firebase
      user.cartReference.add(cartProduct.toCartItemMap()).
        then((doc) => cartProduct.id = doc.documentID);
      //then((doc) => cartProduct.id = doc.documentID) ==> seta o valor novo para o cartProduct.id

    //aqui atualiza o valor
      _onItemUpdated();
    }
    notifyListeners();
  }

  void removeOfCart(CartProduct cartProduct){
    //remove localm o cart, isso faz com que o cart desepareça da lista do carinho
    items.removeWhere((p) => p.id == cartProduct.id);

    //remove diretamente do firebase, atualizando o banco em nuvem.
    user.cartReference.document(cartProduct.id).delete();

    //removendo os listener para não prejudir a performence.
    cartProduct.removeListener(_onItemUpdated);

    //atualizando a tela
    notifyListeners();
  }

  void _onItemUpdated(){
    productPrice = 0.0;

    //aqui faz as mudanças de estado dos produtos dentro do carrinho.
   for(int i = 0; i<items.length; i++){
     final cartProduct = items[i];
     if(cartProduct.quantity == 0){
       removeOfCart(cartProduct);
       i--;
       continue;
     }
     productPrice +=  cartProduct.totalPrice;
     _updateCartProduct(cartProduct);
   }
   notifyListeners();
  }

  void _updateCartProduct(CartProduct cartProduct) {
    if (cartProduct.id != null) {
      user.cartReference.document(cartProduct.id).updateData(
          cartProduct.toCartItemMap());
    }
  }

  bool get isCardValid {
    for(final cartProduct in items){
      if(!cartProduct.hasStock) return false;
    }
    return true;
  }

  bool get isAddressValid => address != null && deliveryPrice != null;

  //TRATANDO A PARTE DE ENDEREÇO
  Future<void> getAddress(String cep) async {

    loading = true;

    final cepAbertoService = CepAbertoServices();

    try{
      final cepAbertoAddress = await cepAbertoService.getAddressFromCep(cep);

      //colocando o conteudo dentro do objeto address, por que se mudar de api, muda apenas a linha acima;
      if(cepAbertoAddress != null){
        address = Address(
          street: cepAbertoAddress.logradouro,
          district: cepAbertoAddress.bairro,
          zipCode: cepAbertoAddress.cep,
          city: cepAbertoAddress.cidade.nome,
          state: cepAbertoAddress.estado.sigla,
          lat: cepAbertoAddress.latitude,
          long: cepAbertoAddress.longitude,
        );
      }
      loading = false;
    } catch (e){
      loading = false;
      return Future.error('CEP Inválido!');
    }
  }

  Future<void> setAddress(Address address) async{
    loading = true;

    this.address = address;

    if(await calculateDelivery(address.lat, address.long)){
      user.setAddress(address);
      loading = false;
    }else{
      loading = false;
      return Future.error('Endereço fora do raio de entrega...');
    }

  }

  Future<bool> calculateDelivery(double lat, double long)async{
    final DocumentSnapshot doc = await firestore.document('aux/delivery').get();

    final latStore = doc.data['lat'] as double;
    final longStore = doc.data['long'] as double;
    final maxkm = doc.data['maxkm'] as num;
    final base = doc.data['base'] as num;
    final km = doc.data['km'] as num;

    double dis = distanceBetween(latStore, longStore, lat, long) as double;
    dis /= 1000.0;

    if(dis > maxkm){
      return false;
    }

    deliveryPrice = base + dis * km;
    return true;
  }

  void removeAddress(){
    address = null;
    deliveryPrice = null;
    notifyListeners();
  }

  void clear() {
    for(final cartProduct in items){
       user.cartReference.document(cartProduct.id).delete();
    }
    items.clear();
    notifyListeners();
  }
}


