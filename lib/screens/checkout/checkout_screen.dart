import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/common/checkout_manager.dart';
import 'package:loja_virtual/common/price_card.dart';
import 'package:loja_virtual/models/cart_manager.dart';
import 'package:provider/provider.dart';

class CheckoutScreen extends StatelessWidget {

  final GlobalKey<ScaffoldState> scaffolKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProxyProvider<CartManager, CheckoutManager>(
      create: (_) => CheckoutManager(),
      update: (_, cartManager, checkoutManager) =>
      checkoutManager..updateCart(cartManager),
      lazy: false,
      child: Scaffold(
        key: scaffolKey,
        appBar: AppBar(
          title: const Text('Pagamento'),
          centerTitle: true,
        ),
        body: Consumer<CheckoutManager>(
          builder: (_, checkOutManager, __) {
            if (checkOutManager.loading) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                    const SizedBox(height: 16,),
                    const Text(
                      'Processando seu Pagamento...',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                          fontStyle: FontStyle.italic
                      ),),
                  ],
                ),
              );
            }
            return ListView(
              children: [
                PriceCard(
                  buttunText: 'Finalizar Pedido',
                  onPressed: () {
                    checkOutManager.checkOut(
                        onStockFail: (e) {
                          Navigator.of(context).popUntil(
                                  (route) => route.settings.name == '/cart');
                        },
                        onSuccess:(order){
                          Navigator.of(context).popUntil(
                                  (route) => route.settings.name == '/');
                          Navigator.of(context).pushNamed('/confirmation', arguments: order);
                        }
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
