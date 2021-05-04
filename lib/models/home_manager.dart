import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/models/section.dart';

class HomeManager extends ChangeNotifier{

  HomeManager(){
    _loadSections();
  }

  final Firestore firestore = Firestore.instance;
  final List<Section> _sections = [];
  List<Section> _editingSections = [];


  bool editing = false;
  bool loading = false;

  //recebendo os itens.
  Future<void> _loadSections() async{
    //usa-se o "snapshots()" para que seja atualizado na tela instantaneamente.
    firestore.collection('home').orderBy('pos').snapshots().listen((snapshot) {
      _sections.clear();
      for(final DocumentSnapshot document in snapshot.documents){
        _sections.add(Section.fromDocument(document));
      }
      notifyListeners();
    });
  }

  void addSection(Section section){
    _editingSections.add(section);
    notifyListeners();
  }

  void removeSection(Section section){
    _editingSections.remove(section);
    notifyListeners();
  }

  List<Section> get sections{
    if(editing){
      return _editingSections;
    } else {
      return _sections;
    }
  }

  void enterEditing(){
    editing = true;
    _editingSections  = _sections.map((s) => s.clone()).toList();
    notifyListeners();
  }

  Future<void> saveEditing() async {
    bool valid = true;
    for(final section in _editingSections){
      if(!section.valid()) valid = false;
    }
    if(!valid) return;

    loading = true;
    notifyListeners();

    int pos = 0;
    for(final section in _editingSections){
      await section.save(pos);
      pos++;
    }

    //verifica se foi deletado a seção, caso não foi vai ser deletada.
    for(final section in List.from(_sections)){
      //não pode ser usado o contains por que está sendo verificado em uma lista clonada, por esse motivo não depo se usado o objeto original
      if(!_editingSections.any((element) => element.id == section.id)){
        await section.delete();
      }
    }


    loading = false;
    editing = false;
    notifyListeners();
  }


  void discartEditing(){
    editing = false;
    notifyListeners();
  }



}