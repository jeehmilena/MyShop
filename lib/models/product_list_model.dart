import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:my_shop/datasource/dummy_data.dart';
import 'package:my_shop/models/product_model.dart';

class ProductListModel with ChangeNotifier {
  final List<ProductModel> _items = dummyProducts;

  List<ProductModel> get items => [..._items];

  List<ProductModel> get favoritesItems =>
      _items.where((product) => product.isFavorite == true).toList();

  int get itemsCount {
    return _items.length;
  }

  void saveProduct(Map<String, Object> data) {
    bool hasId = data['id'] != null;

    final product = ProductModel(
      id: hasId ? data['id'].toString() : Random().nextDouble().toString(),
      title: data['name'].toString(),
      description: data['description'].toString(),
      price: data['price'] as double,
      imageUrl: data['imageUrl'].toString(),
    );

    if (hasId) {
      updateProduct(product);
    } else {
      addProduct(product);
    }
  }

  void addProduct(ProductModel product) {
    _items.add(product);
    notifyListeners();
  }

  void updateProduct(ProductModel product) {
    int index = _items.indexWhere((element) => element.id == product.id);

    if (index >= 0) {
      _items[index] = product;
      notifyListeners();
    }
  }

  void removeProduct(ProductModel product) {
    int index = _items.indexWhere((element) => element.id == product.id);

    if (index >= 0) {
      _items.removeWhere((element) => element.id == product.id);
      notifyListeners();
    }
  }
}
