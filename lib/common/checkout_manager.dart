import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/models/cart_manager.dart';
import 'package:loja_virtual/models/order.dart';
import 'package:loja_virtual/models/product.dart';

class CheckoutManager extends ChangeNotifier {
  CartManager cartManager;

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool value){
    _loading = value;
    notifyListeners();
  }


  Firestore firestore = Firestore.instance;

  // ignore: use_setters_to_change_properties
  void updateCart(CartManager cartManager) {
    //updateCart => serve para atualizar todas as informações do cartManager sempre que tiver uma alteração de usuário, para pegar as infrmações de cada usuário.
    this.cartManager = cartManager;
  }

  Future<void> checkOut({Function onStockFail, Function onSuccess}) async {
    loading = true;

    try{
      await _decrementStock();
    } catch (e){
      onStockFail(e);
      loading = false;
      return;
    }

    // TODO: PROCESSAR PAGAMENTO

    //obtive o orderId
    final orderId = await _getOrderId();

    final order = Order.fromCartManager(cartManager);
    // seto o orderId para a classe Order;
    order.orderId = orderId.toString();
    //agora o pedido vai se salvar no firebase.
    await order.save();

    //limpando o carinho para novas compras
    cartManager.clear();

    onSuccess(order);
    loading = false;
  }

  Future<int> _getOrderId() async {
    final ref = firestore.document(
        'aux/ordercounter'); // ==> referencia o documento no firestore

    // em uma transação semre deve usar a propriedade tx, leitura e escrita
    try {
      final result = await firestore.runTransaction((tx) async {
        final doc = await tx.get(ref); //==> seta o documento para a transação
        final orderId =
            doc.data['current'] as int; //==> pega o valor que esta no firestore
        await tx.update(ref, {
          'current': orderId + 1
        }); //==> atualiza o valor incrementando mais um
        return {'orderId': orderId};
      },
          timeout: const Duration(
              seconds:
                  10)); //==> 10 segundos para fazer a transação completa de geração do id
      return result['orderId'] as int;
    } catch (e) {
      debugPrint(e.toString());
      return Future.error('Falha ao gerar numero do pedido!');
    }
  }

  Future<void> _decrementStock() {
    // 1. Ler todos os estoques
    // 2. Decremento localmente o s estoques
    // 3. Salva os estoques no firebase;

    return firestore.runTransaction((tx) async {
      final List<Product> productsToUpdate = [];
      final List<Product> productsWithoutStock = [];

      for (final cartProduct in cartManager.items) {
        Product product;

        //procedimento para não duplicar o produto caso tenho o memso produto mas com medidas diferentes
        if(productsToUpdate.any((p) => p.id == cartProduct.productId)){
          product = productsToUpdate.firstWhere(
                  (p) => p.id == cartProduct.productId);
        } else{
          final doc = await tx.get(firestore.document(
              'products/${cartProduct.productId}')); // pegandoa referencia do produto e colocando para doc
          product = Product.fromDocument(doc);
        }

        cartProduct.product = product;

        //verificar se tem estoque:
        final size = product.findSize(cartProduct.size);
        if (size.stock - cartProduct.quantity < 0) {
          productsWithoutStock.add(product);
        } else {
          size.stock -= cartProduct.quantity;
          productsToUpdate.add(product);
        }
      }

      if (productsWithoutStock.isNotEmpty) {
        const String descProdut = 'produto';
        if (productsWithoutStock.length > 1) {
          // ignore: unnecessary_statements
          descProdut == 'produtos';
        }
        return Future.error(
            '${productsWithoutStock.length} $descProdut sem estoque');
      }
      
      for(final product in productsToUpdate){
        tx.update(firestore.document('products/${product.id}'),
          {'sizes': product.exportSizeList() });
      }
      
    });
  }
}
