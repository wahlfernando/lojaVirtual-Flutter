import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/models/order.dart';
import 'package:loja_virtual/models/user.dart';

class AdminOrdersManager extends ChangeNotifier{

  User userFilter;

  final List<Order> _orders = [];
  List<Status> mTodos = [];
  
  final List<Status> statusFilter = [Status.preparando]; //aqui ja deixa o preparado ja marcado. opcional tbm.

  StreamSubscription _subscription;

  Firestore firestore = Firestore.instance;

  void updateAdmim({bool admimEnabled}) {
    _orders.clear();
    _subscription?.cancel();

    if(admimEnabled){
      _listenToOrders();
    }
  }


  // procedimento que vai controlar os filtros
  List<Order> get filteredOrders{
    List<Order> output = _orders.reversed.toList();

    // Procedimento que vai pegar o usuário e vai colocar dentro do filtro para seelcionar e trazer os dados somente daquele usuário selecionado pelo filterder
    if(userFilter != null){
      output = output.where((o) => o.userId == userFilter.id).toList();
    }

    //caso queira adicionar mais filtros tem que colocar aqui os filtros.

    return output.where((o) => statusFilter.contains(o.status)).toList();
  }

  void _listenToOrders(){
    _subscription = firestore.collection('orders').snapshots().listen((event) {
     for(final change in event.documentChanges){
       switch(change.type){
         case DocumentChangeType.added:
           _orders.add(Order.fromDocument(change.document));
           break;
         case DocumentChangeType.modified:
           final modOrder = _orders.firstWhere((o) => o.orderId == change.document.documentID);
           modOrder.updateFromDocment(change.document);
           break;
         case DocumentChangeType.removed:
           debugPrint('Deu problema sério em _listenToOrders');
           break;
       }
     }
      notifyListeners();
    });
  }

  void setStatusFilter({Status status, bool enabled}){
    if(enabled){
      statusFilter.add(status);
    } else{
      statusFilter.remove(status);
    }
    notifyListeners();
  }

  void setUserFilter(User user){
     userFilter = user;
     notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    _subscription?.cancel();
  }


}