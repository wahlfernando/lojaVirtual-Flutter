import 'package:flutter/material.dart';
import 'package:loja_virtual/common/price_card.dart';
import 'package:loja_virtual/models/cart_manager.dart';
import 'package:loja_virtual/screens/adress/componentes/address_card.dart';
import 'package:provider/provider.dart';

class AddressScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Entrega'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          AddressCard(),
          Consumer<CartManager>(
            builder: (_, cartManager, __){
              return PriceCard(
                buttunText: 'Continuar para o Pagamento',
                onPressed: cartManager.isAddressValid ? (){
                  Navigator.of(context).pushNamed('/checkout');
                } : null,
              );
            },
          )
        ],
      ),
    );
  }
}
