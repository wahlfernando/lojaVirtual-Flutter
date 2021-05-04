import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loja_virtual/common/custon_drawer/custon_drawer.dart';
import 'package:loja_virtual/models/page_manager.dart';
import 'package:loja_virtual/models/user_manager.dart';
import 'package:loja_virtual/screens/admin_orders/admin_orders_screen.dart';
import 'package:loja_virtual/screens/admin_users/admin_users_screen.dart';
import 'package:loja_virtual/screens/home/home_screen.dart';
import 'package:loja_virtual/screens/orders/orders_screen.dart';
import 'package:loja_virtual/screens/products/products_screen.dart';
import 'package:provider/provider.dart';

class BaseScreen extends StatefulWidget {

  @override
  _BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  final PageController pagecontroller = PageController();


  @override
  void initState() {
    super.initState();

    //Deixa o app sempre em vertical
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => PageManager(pagecontroller),
      child: Consumer<UserManager>(
        builder: (_, userManager, __) {
          return PageView(
            controller: pagecontroller,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              HomeScreen(),
              ProductsScreen(),
              OrdersScreen(),
              Scaffold(
                drawer: CustonDrawer(),
                appBar: AppBar(
                  iconTheme: const IconThemeData(color: Colors.white),
                  title: const Text('Home4'),
                ),
              ),
              if (userManager.adminEnabled)
                ...[
                  AdminUsersScreen(), //Tela de todos os usuários para o administrador
                  AdminOrdersScreen(), // Tela de todos os pedidos para o administrador
                ]
            ],
          );
        },
      ),
    );
  }
}
