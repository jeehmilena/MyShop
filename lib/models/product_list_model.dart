import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:my_shop/datasource/dummy_data.dart';
import 'package:my_shop/models/product_model.dart';

class ProductListModel with ChangeNotifier {
  final List<ProductModel> _items = dummyProducts;
  final _baseUrl = 'https://my-shop-cd670-default-rtdb.firebaseio.com';


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
    http.post(Uri.parse('$_baseUrl/products.json'),
    body: jsonEncode(
      {
        "name": product.title,
        "description": product.description,
        "price": product.price,
        "imageUrl": product.imageUrl,
        "isFavorite":product.isFavorite
      }
    )).then((response){
      final id = jsonDecode(response.body)['name'];
      _items.add(ProductModel(
        id: id,
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        isFavorite: product.isFavorite
      ));
      notifyListeners();
    });
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
