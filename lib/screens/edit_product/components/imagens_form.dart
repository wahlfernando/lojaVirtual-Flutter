import 'dart:io';

import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/models/product.dart';
import 'package:loja_virtual/screens/edit_product/components/image_sorce_sheet.dart';

class ImagesForm extends StatelessWidget {
  const ImagesForm(this.product);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return FormField<List<dynamic>>(
      initialValue: List.from(product.images),
      validator: (images){
        if(images.isEmpty) {
          return 'Insira ao menos uma imagem!';
        }else{
          return null;
        }
      },
      onSaved: (images) => product.newImages = images,
      builder: (state) {
        void onImageSelected(File file){
          state.value.add(file);
          state.didChange(state.value);
          Navigator.of(context).pop();
        }
        return Column(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Carousel(
                images: state.value.map<Widget>((image) {
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      if (image is String)
                        Image.network(
                          image,
                          fit: BoxFit.cover,
                        )
                      else
                        Image.file(image as File, fit: BoxFit.cover),
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: const Icon(
                            Icons.delete_forever,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            state.value.remove(image);
                            state.didChange(state.value);
                          },
                        ),
                      ),
                    ],
                  );
                }).toList()
                  ..add(Material(
                    color: Colors.grey[100],
                    child: IconButton(
                      icon: Icon(
                        Icons.add_a_photo,
                        size: 50,
                        color: Theme.of(context).primaryColor,
                      ),
                      onPressed: () {
                        if (Platform.isAndroid) {
                          showModalBottomSheet(
                            context: context,
                            builder: (_) => ImageSoucesheet(
                              onImageSelected: onImageSelected,
                            ),
                          );
                        } else {
                          showCupertinoModalPopup(
                            context: context,
                            builder: (_) => ImageSoucesheet(
                              onImageSelected: onImageSelected,
                            ),
                          );
                        }
                      },
                    ),
                  )),
                dotSize: 4,
                dotBgColor: Colors.transparent,
                dotColor: Theme.of(context).primaryColor,
                autoplay: false,
                dotSpacing: 15,
              ),
            ),
            if(state.hasError)
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.all(5),
                child: Text(state.errorText, style: const TextStyle(
                  color: Colors.red,
                  fontSize: 15,
                ),),
              )
          ],
        );
      },
    );
  }
}

