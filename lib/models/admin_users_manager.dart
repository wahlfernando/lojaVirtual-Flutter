//classe resposnsavel por buscar todos os usuários do firebase, ou outro banco de dados ou api em comun.

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/models/user.dart';
import 'package:loja_virtual/models/user_manager.dart';

class AdminUsersManager extends ChangeNotifier {

  List<User> users = [];

  final Firestore firestore = Firestore.instance;

  StreamSubscription _subscription;


  void updateUser(UserManager userManager) {
    _subscription?.cancel();
    if (userManager.adminEnabled) {
      _listenToUsers();
    } else{
      users.clear();  //limpando a lista.
      notifyListeners();
    }
  }

  void _listenToUsers() {
    // esse metodo serve para ja trazer todos os usuários cadastrados no app, somente os admim que poderam ver.
    //dessa forma abaixo vai trazer os usuários apenas quando entrar na tela, um novo usuário não aparecerá, somente se sair da tela e entrar nvoamente.
    // firestore.collection('users').getDocuments().then((snaphot) {
    //   users = snaphot.documents.map((e) => User.fromDocument(e)).toList();
    //   users.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    //   notifyListeners();
    // });

    //essa parte de baixo ja mostra como trazer os usuários e atualizar a lista automaticamente
    _subscription = firestore.collection('users').snapshots().listen((snaphot) {
      users = snaphot.documents.map((d) => User.fromDocument(d)).toList();
      users.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      notifyListeners();
    });
  }

  List<String> get names => users.map((e) => e.name).toList();

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

}
