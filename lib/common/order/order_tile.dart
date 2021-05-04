import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:loja_virtual/common/order/cancel_order_dialog.dart';
import 'package:loja_virtual/common/order/export_adrees_dialog.dart';
import 'package:loja_virtual/common/order/order_product_tile.dart';
import 'package:loja_virtual/models/order.dart';

class OrderTile extends StatelessWidget {
  const OrderTile(this.order, {this.showControls = false});

  final Order order;
  final bool showControls;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ExpansionTile(
        // esse widget => ExpansionTile <= faz com que apareça um cardque possa abrir
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  order.formattedId,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: primaryColor,
                  ),
                ),
                Text(
                  'R\$ ${order.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      fontSize: 14),
                ),
              ],
            ),
            Text(
              order.statusText,
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: order.status == Status.cancelado
                      ? Colors.red
                      : primaryColor,
                  fontSize: 14),
            )
          ],
        ),
        backgroundColor: Colors.grey.withAlpha(100),
        children: [
          //children do ExpansionTile
          Column(
            children: order.items.map((e) {
              return OrderProductTile(e);
            }).toList(),
          ),
          if (showControls && order.status != Status.cancelado)
            Column(
              children: [
                Container(
                  margin: EdgeInsets.all(1),
                  //padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: Align(
                    alignment: FractionalOffset(0.1, 0.6),
                    child: Text(
                      'Mudança de Status:',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: primaryColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      FlatButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (_) => CancelOrderDialog(order));
                        },
                        child: const Text('Cancelar'),
                        textColor: Colors.red,
                      ),
                      FlatButton(
                        onPressed: () {
                          order.back;
                        },
                        child: const Text('Recuar'),
                      ),
                      FlatButton(
                        onPressed: () {
                          order.advance;
                        },
                        child: const Text('Avançar'),
                      ),
                      FlatButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (_) =>
                                  ExportAdreesDialog(order.address));
                        },
                        child: const Text('Endereço'),
                        textColor: primaryColor,
                      ),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
