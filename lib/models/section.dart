import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/models/section_item.dart';
import 'package:uuid/uuid.dart';

class Section extends ChangeNotifier{

  Section({this.id, this.name, this.type, this.items}){
   items = items ?? [];  //aqui sabe como que é a seção depois da modificação.
   originalItems = List.from(items);  //aqu ssabe como que é a seção antes da modificação
  }

  Section.fromDocument(DocumentSnapshot document){
    id = document.documentID;
    name = document.data['name'] as String;
    type = document.data['type'] as String;
    items = (document.data['items'] as List).map(
          (i) => SectionItem.fromMap(i as Map<String, dynamic>)).toList();
  }

  final Firestore firestore = Firestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  DocumentReference get firestoreRef => firestore.document('home/$id');
  StorageReference get storageRef => storage.ref().child('home/$id');


  String id;
  String name;
  String type;
  List<SectionItem> items;
  List<SectionItem> originalItems;


  String _error;
  String get error => _error;
  set error(String value){
    _error = value;
    notifyListeners();
  }

  void addItem(SectionItem item){
    items.add(item);
    notifyListeners();
  }

  void removeItem(SectionItem item){
    items.remove(item);
    notifyListeners();
  }

  Future<void> save(int pos) async{
    final Map<String, dynamic> data = {
      'name': name,
      'type': type,
      'pos': pos,
    };

    if(id == null)  {
      final doc = await firestore.collection('home').add(data);
      id = doc.documentID;
    } else {
      await firestoreRef.updateData(data);
    }


    //salvando as imagens
    for(final item in items){
      if(item.image is File){
        final StorageUploadTask task =  storageRef.child(Uuid().v1()).putFile(item.image as File);
        final StorageTaskSnapshot snapshot = await task.onComplete;
        final String url = await snapshot.ref.getDownloadURL() as String;
        item.image = url;
      } 
    }

    for(final original in originalItems){
      if (!items.contains(original) && (original.image as String).contains('firebase')){
        try {
          final ref = await storage.getReferenceFromUrl(
              original.image as String);
          await ref.delete();
        }catch (e){
          debugPrint('Falha ao deletar na função "save()"...');
        }
      }

    }

    final Map<String, dynamic> itemsData = {
      'items': items.map((e) => e.toMap()).toList(),
    };

    await firestoreRef.updateData(itemsData);

  } // fim do save()  //

  Future<void> delete() async{
    await firestoreRef.delete();  // essa linha deleta um sessão no firestore, faz para referencia da sessão. ===> o firestoreRef é  = firestore.document('home/$id')
    for (final item in items) {
      if((item.image as String).contains('firebase')){
        try {
          final ref = await storage.getReferenceFromUrl(
              item.image as String);
          await ref.delete();
        } catch(e) {
          return debugPrint('Erro ao deletar imagem da home');
        }
      }
    }
  }


  bool valid(){
    if(name == null || name.isEmpty){
      error = 'Título Inválido.';
    } else if(items.isEmpty){
      error = 'Insira ao menos uma Imagem.';
    } else {
      error = null;
    }
    return error == null;
  }

  Section clone(){
    return Section(
      id: id,
      name: name,
      type: type,
      items: items.map((e) => e.clone()).toList(),
    );
  }

  @override
  String toString() {
    return 'Section{name: $name, type: $type, items: $items}';
  }
}