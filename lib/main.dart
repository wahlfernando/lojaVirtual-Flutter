import 'package:flutter/material.dart';
import 'package:loja_virtual/models/admin_orders_manager.dart';
import 'package:loja_virtual/models/admin_users_manager.dart';
import 'package:loja_virtual/models/cart_manager.dart';
import 'package:loja_virtual/models/order.dart';
import 'package:loja_virtual/models/orders_manager.dart';
import 'package:loja_virtual/models/product.dart';
import 'package:loja_virtual/models/product_manager.dart';
import 'package:loja_virtual/models/user_manager.dart';
import 'package:loja_virtual/screens/adress/adrees_screen.dart';
import 'package:loja_virtual/screens/base/base_screen.dart';
import 'package:loja_virtual/screens/cart/cart_screen.dart';
import 'package:loja_virtual/screens/checkout/checkout_screen.dart';
import 'package:loja_virtual/screens/confirmation/confirmation_screen.dart';
import 'package:loja_virtual/screens/edit_product/edit_product_screen.dart';
import 'package:loja_virtual/screens/login/login_screen.dart';
import 'package:loja_virtual/screens/product/product_screen.dart';
import 'package:loja_virtual/screens/select_product/select_product_screen.dart';
import 'package:loja_virtual/screens/singup/signup_sreen.dart';
import 'package:provider/provider.dart';
import 'models/home_manager.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserManager(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => ProductManager(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => HomeManager(),
          lazy: false,
        ),
        ChangeNotifierProxyProvider<UserManager, CartManager>(
          create: (_) => CartManager(),
          lazy: false,
          update: (_, userManager, cartmanager) =>
          cartmanager..updateUser(userManager),  // vai ser injetado o user dentro do cartManager, sempre que o user manager sofre uma modificação, o cart vai ser avisado e vai carregar o carinho o usuario em especifico
        ),
        ChangeNotifierProxyProvider<UserManager, OrdersManager>(
          create: (_) => OrdersManager(),
          lazy: false,
          update: (_, userManager, ordersManager) =>
          ordersManager..updateUser(userManager.user),
        ),
        ChangeNotifierProxyProvider<UserManager, AdminUsersManager>(
          create: (_) => AdminUsersManager(),
          lazy: false, //se for true vai retornar apenas quando abrir a tela.
          update: (_, userManager, adminUsersManager) =>
          adminUsersManager..updateUser(userManager),  //
        ),
        ChangeNotifierProxyProvider<UserManager, AdminOrdersManager>(
          create: (_) => AdminOrdersManager(),
          lazy: false,
          update: (_, userManager, adminOrdesManager) =>
          adminOrdesManager..updateAdmim(
            admimEnabled: userManager.adminEnabled
          ),  //
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'e-Marketplace ByAndSell',
        theme: ThemeData(
          primaryColor: const Color.fromARGB(255, 102, 178, 255),
          scaffoldBackgroundColor: const Color.fromARGB(255, 102, 178, 255),
          appBarTheme: const AppBarTheme(
            elevation: 0,
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        //initialRoute: '/base',
        onGenerateRoute: (setings) {
          switch (setings.name) {
            case '/login':
              return MaterialPageRoute(
                  builder: (_) => LoginScreen());
            case '/select_product':
              return MaterialPageRoute(
                  builder: (_) => SelectProductScreen());
            case '/singup':
              return MaterialPageRoute(
                  builder: (_) => SignUpScreen());
            case '/cart':
              return MaterialPageRoute(
                  builder: (_) => CartScreen(),
                  settings: setings);
            case '/address':
              return MaterialPageRoute(
                  builder: (_) => AddressScreen());
            case '/product':
              return MaterialPageRoute(
                  builder: (_) => ProductScreen(
                      setings.arguments as Product));
            case '/edit_product':
              return MaterialPageRoute(
                  builder: (_) => EditProductScreen(
                      setings.arguments as Product));
            case '/checkout':
              return MaterialPageRoute(
                  builder: (_) => CheckoutScreen());
            case '/confirmation':
              return MaterialPageRoute(
                  builder: (_) => ConfirmationScreen(
                    setings.arguments as Order));

            case '/':
            default:
              return MaterialPageRoute(
                  builder: (_) => BaseScreen(),
                  settings: setings
              );
          }
        },
      ),
    );
  }
}


//PROCESSOS DO FIRESTORE:

//Firestore.instance.collection("teste1").add({'teste':'teste'});

//para inclusão
//Firestore.instance.collection("pedidos").document('00001').setData({'preco': 199.99, 'usuario': 'Fernando'});

//busca dados do firebase:
//  DocumentSnapshot document =  await Firestore.instance.collection('usuarios').document('XdMGJUiZ5CHTGksbgcwf').get();
//  print(document.data['nome']);

//traz as atualizações que foram feitas
//  Firestore.instance.collection('usuarios')
//      .document('XdMGJUiZ5CHTGksbgcwf').snapshots().listen((document) {
//     print(document.data);
//  });

//retorno todos os documentos dde uma instancia.
//  QuerySnapshot snapshot = await Firestore.instance.collection('teste1').getDocuments();
//  for(DocumentSnapshot document in snapshot.documents){
//    print(document.data);
//  }