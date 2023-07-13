import 'package:flutter/cupertino.dart';
import 'package:my_shop/datasource/dummy_data.dart';
import 'package:my_shop/models/product.dart';

class ProductList with ChangeNotifier {
  final List<Product> _items = dummyProducts;

  List<Product> get items => [..._items];
  List<Product> get favoritesItems => _items.where((product) => product.isFavorite).toList();

  void addProduct(Product product) {
    _items.add(product);
    notifyListeners();
  }
}
