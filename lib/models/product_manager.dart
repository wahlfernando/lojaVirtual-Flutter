import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loja_virtual/models/product.dart';
import 'package:flutter/material.dart';

class ProductManager extends ChangeNotifier {
  //Construtor
  ProductManager() {
    _loadAllProdycts();
  }

  final Firestore firestore = Firestore.instance;
  List<Product> allProdutcs = [];

  String _search = '';

  String get search => _search;

  set search(String value) {
    _search = value;
    notifyListeners();
  }

  //Lista filtrada
  List<Product> get filteredProducts {
    final List<Product> filteredProducts = [];
    if (search.isEmpty) {
      filteredProducts.addAll(allProdutcs);
    } else {
      filteredProducts.addAll(allProdutcs
          .where((p) => p.name.toLowerCase().contains(search.toLowerCase())));
    }
    return filteredProducts;
  }

  Future<void> _loadAllProdycts() async {
    final QuerySnapshot snapshot =
        await firestore.collection('products').where('deleted', isEqualTo: false).getDocuments();

    allProdutcs = snapshot.documents.map((d) => Product.fromDocument(d)).toList();
    notifyListeners();
  }

  void update(Product product){
    allProdutcs.removeWhere((p) => p.id == product.id);
    allProdutcs.add(product);
    notifyListeners();
  }

  Product findProdyctById(String id){
    try{
      return allProdutcs.firstWhere((p) => p.id == id);
    }catch (e) {
      return null;
    }
  }

  void delete(Product product) {
    product.delete();
    allProdutcs.removeWhere((p) => p.id == product.id);
    notifyListeners();
  }
}
