import 'package:flutter/material.dart';
import 'package:loja_virtual/models/order.dart';

class CancelOrderDialog extends StatelessWidget {
  //para passar o pedido por parametro temque fazer uns contrutor e o que objeto que for passar por parametro
  // deve estar setado tbm, caso contrário não da certo.

  const CancelOrderDialog(this.order);

  final Order order;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Cancelar ${order.formattedId}?'),
      content: const Text('Essa ação não poderá ser desfeita!'),
      actions: [
        FlatButton(
            onPressed: () {
              order.cancel();
              Navigator.of(context).pop();
            },
            child: Text('Cancelar Pedido'),
          textColor: Colors.red,
        ),
      ],
    );
  }
}
