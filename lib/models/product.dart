import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/models/item_size.dart';
import 'package:uuid/uuid.dart';

class Product extends ChangeNotifier{

  //Construtor
  Product({this.id, this.name, this.description, this.images, this.sizes, this.deleted = false}){
    images = images ?? [];
    sizes = sizes ?? [];
  }

  Product.fromDocument(DocumentSnapshot document){
    id = document.documentID;
    name = document['name'] as String;
    description = document['description'] as String;
    //nas imagens tem que transformar em uma lista dinamica
    images = List<String>.from(document.data['images'] as List<dynamic>);
    deleted = (document.data['deleted'] ?? false) as bool;
    sizes = (document.data['sizes'] as List<dynamic> ?? []).map(
            (s) => ItemSize.fromMap(s as Map<String, dynamic>)).toList();
  }

  //DECLARANDO AS REFERENCIAS PARA O FIREBASE:
  final Firestore firestore = Firestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  // busca o documento relativo que está editando no momento
  DocumentReference get firestoreRef => firestore.document('products/$id');
  
  //Referencia para a pasta que vai ser armazenada a imagem no firebase no Sotage;
  StorageReference get storageRef => storage.ref().child('products').child(id);



  String id;
  String name;
  String description;
  List<String> images;
  List<ItemSize> sizes;
  List<dynamic> newImages;
  bool deleted;

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool value){
    _loading = value;
    notifyListeners();
  }

  ItemSize _selectedSize;
  ItemSize get selectedSize => _selectedSize; //(o simbolo de '=>' siginifica: retornar)
  set selectedSize(ItemSize valeu){
    _selectedSize = valeu;
    notifyListeners();
  }

  int get totalStock{
    int stock = 0;
    for(final size in sizes){
      stock += size.stock;
    }
    return stock;
  }

  bool get hasStock{
    return totalStock > 0 && !deleted;
  }

  num get basePrice{
    num lowest = double.infinity;
    for(final size in sizes){
      if(size.price < lowest){
        lowest = size.price;
      }
    }
    return lowest;
  }

  ItemSize findSize(String name){
    try {
      return sizes.firstWhere((s) => s.name == name);
    } catch (e){
      return null;
    }
  }

  List<Map<String, dynamic>> exportSizeList(){
    return sizes.map((sizes) => sizes.toMap()).toList();
  }

  //Função para salvar o conteúdo.
  Future<void> save() async {
    loading = true;
    final Map<String, dynamic> data = {
      'name': name,
      'description': description,
      'sizes': exportSizeList(),
      'deleted': deleted,
    };
    
    if(id ==  null)  {
      //salvando um novo produto
      final doc = await firestore.collection('products').add(data);
      id = doc.documentID;
    } else {
      // salvando um produto ja existente(somente os dados digitados)
      await firestoreRef.updateData(data);
    }
    final List<String> updateImages = [];

    //verificação de imagens e recolocação de novas imagens a lista de newImages.
    // esse procedimento ja salva as imegens no Storage = (pastas de arquivos ) do Firebase
    for(final newImages in newImages){
      if(images.contains(newImages)){
        updateImages.add(newImages as String);
      } else {
        final StorageUploadTask task =  storageRef.child(Uuid().v1()).putFile(newImages as File);
        final StorageTaskSnapshot snapshot = await task.onComplete;
        final String url = await snapshot.ref.getDownloadURL() as String;
        updateImages.add(url);
      }
    }

    //procesos de remoção das imagens para não sobrecarregar no sotorege do firebase
    //sempre que tiver uma imagem duplicada os procesos abaixo vai fazer com que essa imagem seja deletada
    for(final image in images){
      if(!newImages.contains(image) && image.contains('firebase')){
        try {
          final ref = await storage.getReferenceFromUrl(image);
          await ref.delete();
        } catch (e){
          debugPrint('Falha ao deletar $image');
        }
      }
    }

    //salvando a lista de novas imagens
    await firestoreRef.updateData({'images': updateImages});

    images = updateImages;
    loading = false;
  }

  void delete() {
    firestoreRef.updateData({'deleted' : true});
  }

  Product clone(){
    return Product(
      id: id,
      name: name,
      description: description,
      images: List.from(images),
      sizes: sizes.map((size) => size.clone()).toList(),
      deleted: deleted,
    );
  }

  @override
  String toString() {
    return 'Product{id: $id, name: $name, description: $description, images: $images, sizes: $sizes, newImages: $newImages}';
  }


}