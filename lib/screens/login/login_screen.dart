import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:loja_virtual/models/user.dart';
import 'package:loja_virtual/models/user_manager.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/helpers/validators.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text("Entrar"),
        centerTitle: true,
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/singup');
            },
            child: const Text('CRIAR CONTA'),
            textColor: Colors.white,
          ),
        ],
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: formKey,
            child: Consumer<UserManager>(
              builder: (_, userManager, filho) {
                return ListView(
                  padding: const EdgeInsets.all(16),
                  shrinkWrap: true,
                  children: [
                    TextFormField(
                      controller: emailController,
                      enabled: !userManager.loading,
                      decoration: const InputDecoration(hintText: 'E-mail'),
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      validator: (email) {
                        if (!emailValidator(email)) {
                          return 'E-mail Inválido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      controller: passController,
                      enabled: !userManager.loading,
                      decoration: const InputDecoration(hintText: 'Senha'),
                      autocorrect: false,
                      obscureText: true,
                      validator: (pass) {
                        if (pass.isEmpty || pass.length < 6) {
                          return 'Senha Inválida';
                        }
                        return null;
                      },
                    ),
                    filho,
                    const SizedBox(
                      height: 16,
                    ),
                    RaisedButton(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      onPressed: userManager.loading
                          ? null
                          : () {
                              if (formKey.currentState.validate()) {
                                userManager.singIn(
                                    user: User(
                                      email: emailController.text,
                                      password: passController.text,
                                    ),
                                    onFail: (e) {
                                      scaffoldKey.currentState.showSnackBar(
                                        SnackBar(
                                          content:
                                              Text('Falha ao entrar: $e'),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    },
                                    onSuccsses: () {
                                      Navigator.of(context).pop();
                                    });
                              }
                            },
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      disabledColor:
                          Theme.of(context).primaryColor.withAlpha(0),
                      child: userManager.loading
                          ? const CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation(Colors.white),
                            )
                          : const Text(
                              'Entrar',
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                    ),
                    SignInButton(
                      Buttons.Facebook,
                      text: 'Entrar com Facebook',
                      elevation: 2,
                      onPressed: () {
                        userManager.facebookLogin();
                      },
                    )
                  ],
                );
              },
              child: Align(
                alignment: Alignment.centerRight,
                child: FlatButton(
                  onPressed: () {},
                  padding: EdgeInsets.zero,
                  child: const Text('Esqueci mminha senha'),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
