import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/models/order.dart';
import 'package:loja_virtual/models/user.dart';

class OrdersManager extends ChangeNotifier{
  User user;
  List<Order> orders = [];
  StreamSubscription _subscription;

  Firestore firestore = Firestore.instance;

  void updateUser(User user) {
    this.user = user;
    orders.clear();
    _subscription?.cancel();

    if(user != null){
        _listenToOrders();
    }
  }

  void _listenToOrders(){
    _subscription = firestore.collection('orders').where('user', isEqualTo: user.id).snapshots().listen((event) {
      orders.clear();
      for(final doc in event.documents){
        orders.add(Order.fromDocument(doc));
      }
      notifyListeners();
    });

  }


  @override
  void dispose() {
    super.dispose();
    _subscription?.cancel(); // verifica se é nulo, isso tem que ser feito se não sempre vai aciumulando os pedidos de vários usuários diferentes.
  }

}

