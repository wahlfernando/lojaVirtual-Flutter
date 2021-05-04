import 'package:flutter/material.dart';
import 'package:loja_virtual/common/line_decorarion.dart';
import 'package:loja_virtual/models/product.dart';
import 'package:loja_virtual/models/product_manager.dart';
import 'package:loja_virtual/screens/edit_product/components/sizes_form.dart';
import 'package:provider/provider.dart';

import 'components/imagens_form.dart';

class EditProductScreen extends StatelessWidget {
  EditProductScreen(Product p)
      : editing = p != null,
        product = p != null ? p.clone() : Product();

  final Product product;
  final bool editing;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return ChangeNotifierProvider.value(
      value: product,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(editing ? 'Editar Produto' : 'Criar Produto'),
          centerTitle: true,
          actions: [
            if(editing)
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: (){
                  context.read<ProductManager>().delete(product);
                  Navigator.of(context).pop();
                },
              )
          ],
        ),
        body: Form(
          key: formKey,
          child: ListView(
            children: [
              ImagesForm(product),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      initialValue: product.name,
                      decoration: const InputDecoration(
                          hintText: 'Título', border: InputBorder.none),
                      style: const TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w600,
                      ),
                      validator: (name) {
                        if (name.length < 6) {
                          return 'Título muito curto.';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (name) => product.name = name,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        'A partid de',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Text(
                      'R\$ ...',
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Text(
                        'Descrição',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w500),
                      ),
                    ),
                    TextFormField(
                      initialValue: product.description,
                      style: const TextStyle(fontSize: 16),
                      decoration: const InputDecoration(
                          hintText: 'Descrição', border: InputBorder.none),
                      maxLines: null,
                      validator: (desc) {
                        if (desc.length < 10) {
                          return 'Descrição muito curta.';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (desc) => product.description = desc,
                    ),
                    SizesForm(product),
                    const SizedBox(
                      height: 20,
                    ),
                    LineDecoration(),
                    Consumer<Product>(
                      builder: (_, product, __) {
                        return SizedBox(
                          height: 50,
                          child: RaisedButton(
                            onPressed: !product.loading ? () async {
                                    //apenas vaio salvar se for valido a imagem
                                    if (formKey.currentState.validate()) {
                                      formKey.currentState.save();
                                      await product.save();
                                      context.read<ProductManager>().update(product);
                                      Navigator.of(context).pop();
                                    }
                                  }
                                : null,
                            child: product.loading
                                ? const CircularProgressIndicator(
                                    valueColor:AlwaysStoppedAnimation(Colors.white),)
                                : const Text('Salvar',
                                    style: TextStyle(fontSize: 18),),
                            textColor: Colors.white,
                            color: primaryColor,
                            disabledColor: primaryColor.withAlpha(100),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
