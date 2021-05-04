import 'package:flutter/material.dart';
import 'package:loja_virtual/models/item_size.dart';
import 'package:loja_virtual/models/product.dart';
import 'package:provider/provider.dart';


class SizeWidgt extends StatelessWidget {
  const SizeWidgt({this.size}); //construtor

  final ItemSize size;

  @override
  Widget build(BuildContext context) {
    final product = context.watch<Product>();
    final selected = size == product.selectedSize;

    Color color;
    if(!size.hasStock) {
      color = Colors.red.withAlpha(50);
    } else if(selected) {
      color = Theme.of(context).primaryColor;
    } else {
      color = Colors.grey;
    }

    //possivelmente aqui vai ter um GestureDetector para poder clicar e efetuar algum evento
    return GestureDetector(
      onTap: (){
        if(size.hasStock){
          product.selectedSize = size;
        }
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: color,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              color: color,
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: Text(
                size.name,
                style: const TextStyle(color: Colors.white),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'R\$ ${size.price.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 16,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
