import 'package:flutter/material.dart';
import 'package:loja_virtual/common/empty_card.dart';
import 'package:loja_virtual/common/login_card.dart';
import 'package:loja_virtual/common/price_card.dart';
import 'package:loja_virtual/models/cart_manager.dart';
import 'package:provider/provider.dart';
import 'components/cart_tile.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrinho'),
        centerTitle: true,
      ),
      body: Consumer<CartManager>(
        //no builder é assim: contexto que não importa muito, a "variavel" para uso que vai chamaro objeto, e o filho que não vai ser usado em muitos casos
        builder: (_, cartManager, __) {
          //verificando se tem algum usuário logado:
          if (cartManager.user == null) {
            return LoginCard();
          }

          if (cartManager.items.isEmpty) {
            return const EmptyCard(
              iconData: Icons.remove_shopping_cart,
              title: 'Nenhum produto no carrinho!',
            );
          }

          return ListView(
            children: [
              Column(
                //vamos pegar cada item do carrinhoe transformar em CardTile. Nesse caso que realemnte vai construir a tela com os cards
                children: cartManager.items
                    .map((cartProduct) => CartTile(cartProduct))
                    .toList(),
                //o CartTile que faz a tela para aparecer os carts do carrinho.
              ),
              PriceCard(
                buttunText: 'Continuar para Entrega',
                onPressed: cartManager.isCardValid
                    ? () {
                        Navigator.of(context).pushNamed('/address');
                      }
                    : null,
              ),

            ],
          );
        },
      ),
    );
  }
}
