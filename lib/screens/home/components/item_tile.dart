import 'dart:io';
import 'package:flutter/material.dart';
import 'package:loja_virtual/models/home_manager.dart';
import 'package:loja_virtual/models/product.dart';
import 'package:loja_virtual/models/product_manager.dart';
import 'package:loja_virtual/models/section.dart';
import 'package:loja_virtual/models/section_item.dart';
import 'package:loja_virtual/screens/select_product/select_product_screen.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

class ItemTile extends StatelessWidget {
  const ItemTile(this.item);

  final SectionItem item;

  @override
  Widget build(BuildContext context) {
    final homeManager = context.watch<HomeManager>();
    return GestureDetector(
      onTap: () {
        if (item.product != null) {
          final product =
              context.read<ProductManager>().findProdyctById(item.product);
          if (product != null) {
            Navigator.of(context).pushNamed('/product', arguments: product);
          }
        }
      },
      onLongPress: homeManager.editing ? (){
        showDialog(
          context: context,
          builder: (_){
            final product = context.read<ProductManager>().findProdyctById(item.product);
            return AlertDialog(
              content: product != null
              ? ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Image.network(product.images.first),
                title: Text(product.name),
                subtitle: Text('R\$ ${product.basePrice.toStringAsFixed(2)}'),
              )
              : null,
              title: const Text('Editar Item'),
              actions: [
                FlatButton(
                  textColor: Colors.red,
                  onPressed: (){
                    context.read<Section>().removeItem(item);
                    Navigator.of(context).pop();
                  },
                    child: const Text('Excluir')
                ),
                FlatButton(
                  onPressed: () async{
                    if(product != null){
                      item.product = null;
                    } else {
                      final Product product = await Navigator.of(context).pushNamed('/select_product') as Product;
                      item.product = product?.id;
                    }
                    Navigator.of(context).pop();
                  },
                  child: Text(product != null
                      ? 'Desvincular Produto'
                      : 'Vincular Produto'
                    ),
                )
              ],
            );
          }
        );
      } : null,
      child: AspectRatio(
        aspectRatio: 1,
        child: item.image is String
          ? FadeInImage.memoryNetwork(
            placeholder: kTransparentImage,
            image: item.image as String,
            fit: BoxFit.cover,
          )
        : Image.file(item.image as File, fit: BoxFit.cover,)

      ),
    );
  }
}
// dessa forma aqui em baixo as imagens aparecem de uam forma muito brusca
// Image.network(
// item.image,
// fit: BoxFit.cover, //deixando a imagem quarada
// ),
