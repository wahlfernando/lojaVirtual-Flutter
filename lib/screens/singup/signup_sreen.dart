import 'package:flutter/material.dart';
import 'package:loja_virtual/helpers/validators.dart';
import 'package:loja_virtual/models/user.dart';
import 'package:loja_virtual/models/user_manager.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatelessWidget {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final User user = User();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text('Criar Conta'),
        centerTitle: true,
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: formKey,
            child: Consumer<UserManager>(builder: (_, userManager, __) {
              return ListView(
                padding: const EdgeInsets.all(16),
                shrinkWrap: true,
                children: [
                  TextFormField(
                    enabled: !userManager.loading,
                    decoration:
                        const InputDecoration(hintText: 'Nome Completo'),
                    validator: (name) {
                      if (name.isEmpty) {
                        return 'Campo Obrigatório';
                      } else if (name.trim().split(' ').length <= 1) {
                        return 'Preencha seu Nome Completo';
                      }
                      return null;
                    },
                    onSaved: (name) => user.name = name,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    enabled: !userManager.loading,
                    decoration: const InputDecoration(hintText: 'E-mail'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (email) {
                      if (email.isEmpty) {
                        return 'Caompo Obrigatório';
                      } else if (!emailValidator(email)) {
                        return 'E-Mail Inválido';
                      }
                      return null;
                    },
                    onSaved: (email) => user.email = email,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    enabled: !userManager.loading,
                    decoration: const InputDecoration(hintText: 'Senha'),
                    obscureText: true,
                    validator: (pass) {
                      if (pass.isEmpty) {
                        return 'Caompo Obrigatório';
                      } else if (pass.length < 6) {
                        return 'Senha Muito Curta';
                      }
                      return null;
                    },
                    onSaved: (pass) => user.password = pass,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    enabled: !userManager.loading,
                    decoration:
                        const InputDecoration(hintText: 'Repita a Senha'),
                    obscureText: true,
                    validator: (pass) {
                      if (pass.isEmpty) {
                        return 'Caompo Obrigatório';
                      } else if (pass.length < 6) {
                        return 'Senha Muito Curta';
                      }
                      return null;
                    },
                    onSaved: (confirmPassword) =>
                        user.confirmPassaword = confirmPassword,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  FlatButton(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    disabledColor: Theme.of(context).primaryColor.withAlpha(0),
                    onPressed: userManager.loading
                        ? null
                        : () {
                            if (formKey.currentState.validate()) {
                              formKey.currentState.save();
                              if (user.password != user.confirmPassaword) {
                                scaffoldKey.currentState.showSnackBar(
                                  const SnackBar(
                                    content: Text('Senha não Coincidem!'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              }
                              userManager.singUp(
                                    user: user,
                                    onSuccsses: () {
                                      Navigator.of(context).pop();
                                    },
                                    onFail: (e) {
                                      scaffoldKey.currentState.showSnackBar(
                                        SnackBar(
                                          content:
                                              Text('Falha ao cadastrar: $e'),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    },
                                  );
                            }
                          },
                    child: userManager.loading ?
                    const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    )
                    : const Text(
                      'Criar Conta',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
