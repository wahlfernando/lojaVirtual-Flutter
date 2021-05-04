import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/models/address.dart';
import 'package:loja_virtual/models/cart_manager.dart';
import 'package:loja_virtual/models/cart_product.dart';

enum Status {
  cancelado,
  emAnalise,
  preparando,
  transportando,
  entregue,
  entregue1,
  entregue2,
  entregue3
}

class Order {
//construtores
  Order.fromCartManager(CartManager cartManager) {
    items = List.from(cartManager.items);
    price = cartManager.totalPrice;
    userId = cartManager.user.id;
    address = cartManager.address;
    status = Status.emAnalise;
  }

  Order.fromDocument(DocumentSnapshot doc) {
    orderId = doc.documentID;

    items = (doc.data['items'] as List<dynamic>).map((e) {
      return CartProduct.fromMap(e as Map<String, dynamic>);
    }).toList();
    price = doc.data['price'] as num;
    userId = doc.data['user'] as String;
    address = Address.fromMap(doc.data['address'] as Map<String, dynamic>);
    date = doc.data['date'] as Timestamp;
    status = Status.values[doc.data['status'] as int];
  }
// fim contrutores

  void updateFromDocment(DocumentSnapshot doc){
    status = Status.values[doc.data['status'] as int];
  }


  Future<void> save() async {
    firestore.collection('orders').document(orderId).setData({
      'items': items.map((e) => e.toOrderItemMap()).toList(),
      'price': price,
      'user': userId,
      'address': address.toMap(),
      'status': status.index,
      'date': Timestamp.now(),
    });
  }

  Function() get back {
    if(status.index >= Status.preparando.index) {
      status = Status.values[status.index - 1];
      firestoreRef.updateData({'status': status.index});
    } else {
      return null;
    }
  }

  Function() get advance {
    if(status.index <= Status.entregue2.index) {
      status = Status.values[status.index + 1];
      firestoreRef.updateData({'status': status.index});
    } else{
      return null;
    }
  }

  void cancel(){
    status = Status.cancelado;
    firestoreRef.updateData({'status': status.index});
  }

  final Firestore firestore = Firestore.instance;
  DocumentReference get firestoreRef => firestore.collection('orders').document(orderId);

  String orderId;
  List<CartProduct>
      items; //essa lista é a lista de produtos que estava no carrinho quando foi feita a compra.
  num price;
  String userId;
  Address address;
  Timestamp date;
  Status status;

  String get formattedId => '#${orderId.padLeft(8, '0')}';

  String get statusText => getStatusText(status);

  static String getStatusText(Status status) {
    switch (status) {
      case Status.cancelado:
        return 'Cancelado';
      case Status.emAnalise:
        return 'Em Análise';
      case Status.preparando:
        return 'Preparando';
      case Status.transportando:
        return 'Em Transporte';
      case Status.entregue:
        return 'Entregue';
      case Status.entregue1:
        return '1º Tentativa de Entrega';
      case Status.entregue2:
        return '2º Tentativa de Entrega';
      case Status.entregue3:
        return 'Sem retorno/ mudou endereço';
      default:
        return '';
    }
  }

  @override
  String toString() {
    return 'Order{firestore: $firestore, orderId: $orderId, items: $items, price: $price, userId: $userId, address: $address, date: $date}';
  }
}
