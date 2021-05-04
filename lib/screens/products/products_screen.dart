import 'package:flutter/material.dart';
import 'package:loja_virtual/common/custon_drawer/custon_drawer.dart';
import 'package:loja_virtual/models/product_manager.dart';
import 'package:loja_virtual/models/user_manager.dart';
import 'package:loja_virtual/screens/products/components/products_list_tile.dart';
import 'package:provider/provider.dart';

import 'components/search_dialog.dart';

class ProductsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustonDrawer(),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Consumer<ProductManager>(
          builder: (_, productManager, __){
            if(productManager.search.isEmpty){
              return const Text('Produtos', style: TextStyle(color: Colors.white));
            } else{
              return LayoutBuilder(
                  builder: (_, constrains){

                  return GestureDetector(
                    onTap: ()async {
                      final search = await showDialog<String>(
                          context: context, builder: (_) => SearchDialog(productManager.search));
                      if(search != null){
                        productManager.search = search;
                      }
                    },
                    child: Container(
                      width: constrains.biggest.width,
                      child: Text(productManager.search, textAlign: TextAlign.center,),
                    ),
                  );
                }
              );
            }
          }
        ),
        centerTitle: true,
        actions: [
          Consumer<ProductManager>(
              builder: (_, productManager, __){
                if(productManager.search.isEmpty){
                  return IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () async {
                      final search = await showDialog<String>(
                          context: context, builder: (_) => SearchDialog(productManager.search));
                      if(search != null){
                        productManager.search = search;
                      }
                    },
                  );
                } else{
                  return IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () async {
                      productManager.search = '';
                    },
                  );
                }
              }
          ),
          Consumer<UserManager>(
            builder: (_, userManager, __){
              if(userManager.adminEnabled){
                return IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: (){
                      Navigator.of(context).pushNamed('/edit_product');
                    });
              } else {
                return Container();
              }
            },
          )
        ],
      ),
      body: Consumer<ProductManager>(
        builder: (_, productManager, __) {
          final filteredProducts = productManager.filteredProducts;
          return ListView.builder(
            itemCount: filteredProducts.length,
            itemBuilder: (_,index,) {
              return ProductListTile(filteredProducts[index]);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        foregroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          Navigator.of(context).pushNamed('/cart');
        },
        child: const Icon(Icons.shopping_cart),
      ),
    );
  }
}
