import 'package:flutter/cupertino.dart';
import 'package:my_shop/datasource/dummy_data.dart';
import 'package:my_shop/models/product_model.dart';

class ProductListModel with ChangeNotifier {
  final List<ProductModel> _items = dummyProducts;

  List<ProductModel> get items => [..._items];
  List<ProductModel> get favoritesItems =>
      _items.where((product) => product.isFavorite == true).toList();

  void addProduct(ProductModel product) {
    _items.add(product);
    notifyListeners();
  }
}
