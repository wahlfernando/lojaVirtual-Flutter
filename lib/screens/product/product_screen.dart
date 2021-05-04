import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/models/cart_manager.dart';
import 'package:loja_virtual/models/product.dart';
import 'package:loja_virtual/models/user_manager.dart';
import 'package:provider/provider.dart';

import 'components/size_widget.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen(this.product);

  final Product product;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return ChangeNotifierProvider.value(
      value: product,
      child: Scaffold(
        appBar: AppBar(
          title: Text(product.name),
          centerTitle: true,
          actions: [
            Consumer<UserManager>(
              builder: (_, userManager, __){
                if(userManager.adminEnabled && !product.deleted){
                  return IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: (){
                        Navigator.of(context).pushReplacementNamed('/edit_product', arguments: product);
                      });
                } else {
                  return Container();
                }
              },
            ),
          ],
        ),
        backgroundColor: Colors.white,
        body: ListView(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Carousel(
                images: product.images.map((url) {
                  return NetworkImage(url);
                }).toList(),
                dotSize: 4,
                dotBgColor: Colors.transparent,
                dotColor: primaryColor,
                autoplay: false,
                dotSpacing: 15,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      'A partid de',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Text(
                    'R\$ ${product.basePrice.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 16, bottom: 8),
                    child: Text(
                      'Descrição',
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Text(
                    product.description,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  if(product.deleted)
                    const Padding(
                      padding: EdgeInsets.only(top: 16, bottom: 8),
                      child:  Text('Este produto não está mais disponível!',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500 ,
                              color: Colors.redAccent)
                      ),
                    )
                  else
                  ...[const Padding(
                    padding: EdgeInsets.only(top: 16, bottom: 8),
                    child: Text(
                      'Tamanhos',
                      style:
                      TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                    ),
                  ),
                    //Componente para deixar umdo lado do outro e quando termina o expaço lateral ele alocao o widget abaixo, evitando erro de overflow:
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: product.sizes.map((s) {
                        return SizeWidgt(size: s);
                      }).toList(),
                    ),],
                  const SizedBox(
                    height: 20,
                  ),
                  if (product.hasStock)
                    Consumer2<UserManager, Product>(
                        builder: (_, userManager, product, __) {
                      return SizedBox(
                        height: 44,
                        child: RaisedButton(
                          onPressed: product.selectedSize != null
                              ? () {
                                  if (userManager.isLoggedIn) {
                                    //procedimento para adicionar no carrinho
                                    context
                                        .read<CartManager>()
                                        .addToCart(product);
                                    //agora vai para o carrinho, não sei se faz sentido colocar aqui mas tudo bem
                                    Navigator.of(context).pushNamed('/cart');
                                  } else {
                                    Navigator.of(context).pushNamed('/login');
                                  }
                                }
                              : null,
                          color: primaryColor,
                          textColor: Colors.white,
                          child: Text(
                            userManager.isLoggedIn
                                ? 'Adicionar o Carrinho'
                                : 'Entre para Comprar',
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                      );
                    })
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
