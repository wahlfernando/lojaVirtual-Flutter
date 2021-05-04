import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/common/order/order_product_tile.dart';
import 'package:loja_virtual/models/order.dart';

class ConfirmationScreen extends StatelessWidget {
  const ConfirmationScreen(this.order);

  final Order order;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ped. ${order.formattedId} Confirmado',
          style: TextStyle(fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(16),
          child: ListView(
            shrinkWrap: true,
            children: [
              Padding(padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      order.formattedId,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  Text(
                    'R\$ ${order.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        fontSize: 14
                    ),
                  ),
                ],
              ),
              ),
              Column(
                children: order.items.map((e) {
                  return OrderProductTile(e);
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
