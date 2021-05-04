import 'package:flutter/material.dart';
import 'package:loja_virtual/models/cart_manager.dart';
import 'package:provider/provider.dart';

class PriceCard extends StatelessWidget {

  PriceCard({this.onPressed, this.buttunText});

  final String buttunText;
  final VoidCallback onPressed;


  @override
  Widget build(BuildContext context) {
    final cartManager = context.watch<CartManager>();
    final productPrice = cartManager.productPrice;
    final deliveryPrice = cartManager.deliveryPrice;
    final totalPrice = cartManager.totalPrice;


    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Resumo do Pedido',
              textAlign: TextAlign.start,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
            ),
            const SizedBox(
              height: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //maximo espaço ENTRE os widgets
              children: [
                const Text(
                  'Subtotal',
                ),
                Text('R\$ ${productPrice.toStringAsFixed(2)}'),
              ],
            ),
            const Divider(),
            if(deliveryPrice !=  null)
              ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //maximo espaço ENTRE os widgets
                  children: [
                    const Text(
                      'Entrega',
                    ),
                    Text('R\$ ${deliveryPrice.toStringAsFixed(2)}'),
                  ],
                ),
                const Divider(),
              ],
            const SizedBox(
              height: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  'R\$ ${totalPrice.toStringAsFixed(2)}',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).primaryColor,
                      fontSize: 16),
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            RaisedButton(
              disabledColor: Theme.of(context).primaryColor.withAlpha(100),
              onPressed: onPressed,
              color: Theme.of(context).primaryColor,
              textColor: Colors.white,
              child: Text(buttunText),
            ),
          ],
        ),
      ),
    );
  }
}
