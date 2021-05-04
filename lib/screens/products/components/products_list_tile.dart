import 'package:flutter/material.dart';
import 'package:loja_virtual/models/product.dart';

class ProductListTile extends StatelessWidget {

  const ProductListTile(this.product);
  final Product product;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.of(context).pushNamed('/product', arguments: product);
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          //para ter o efeito de bordas
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Container(
            height: 100,
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: Image.network(product.images.first),
                ),
                const SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w800),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4),
                        child: Text(
                          'A partir de',
                          style: TextStyle(color: Colors.grey[400], fontSize: 12),
                        ),
                      ),
                       Text(
                        'R\$ ${product.basePrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: Colors.indigo
                        ),
                      ),
                      if(!product.hasStock)
                        const Padding(
                            padding: EdgeInsets.only(top: 4),
                          child: Text('Sem Estoque',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 10
                            )),
                        )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
