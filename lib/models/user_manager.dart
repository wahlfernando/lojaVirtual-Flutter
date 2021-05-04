import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:loja_virtual/helpers/firebase_erros.dart';
import 'package:loja_virtual/models/user.dart';

class UserManager extends ChangeNotifier {
  UserManager() {
    _loadCurrentUser();
  }

  final FirebaseAuth auth = FirebaseAuth.instance;
  final Firestore firestore = Firestore.instance;

  bool _loading = false;
  bool get loading => _loading;
  bool get isLoggedIn => user != null;

  User user;

  Future<void> singIn({User user, Function onFail, Function onSuccsses}) async {
    try {
      loading = true;
      final AuthResult result = await auth.signInWithEmailAndPassword(email: user.email.trim(), password: user.password);
      await _loadCurrentUser(firebaseUser: result.user);
      this.user = user;

      onSuccsses();
    } on PlatformException catch (e) {
      onFail(getErrorString(e.code));
    }
    loading = false;
    //
    notifyListeners();
  }

  void facebookLogin() {
  // =======>>>> para fazer o processo de login com face tem que assistir a aula 133 e 134 <<<<======= \\
  }

  Future<void> singUp({User user, Function onFail, Function onSuccsses}) async {
    try {
      loading = true;
      final AuthResult result = await auth.createUserWithEmailAndPassword(
          email: user.email, password: user.password);
      
      user.id = result.user.uid;

      await user.saveData();

      onSuccsses();

    } on PlatformException catch (e) {
      onFail(getErrorString(e.code));
    }
    loading = false;
  }

  void singOut(){
    auth.signOut();
    user = null;
    notifyListeners();
  }

  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> _loadCurrentUser({FirebaseUser firebaseUser}) async {
    FirebaseUser currentUser = firebaseUser ?? await auth.currentUser();
    if (currentUser != null) {
      final DocumentSnapshot docUser = await firestore.collection('users').document(currentUser.uid).get();
      user = User.fromDocument(docUser);

      //essa linha abaixo busca um documento cujo o id é o mesmo id do usuario na coleção do usuarios, se existir dai ele quer dizer que é um ID.
      final docAdmin = await firestore.collection('admins').document(user.id).get();

      if(docAdmin.exists){
        user.admim = true;
      }

      notifyListeners();
    }
  }

  //aquyi indica que se o usario for diferente de nulo e admim, quer dizer que o admimEnabled está habilitado.
  bool get adminEnabled => user != null && user.admim;



}
