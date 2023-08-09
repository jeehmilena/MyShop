import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:my_shop/exceptions/http_exception.dart';
import 'package:my_shop/models/product_model.dart';
import 'package:my_shop/utils/constants.dart';

class ProductListModel with ChangeNotifier {
  String _token;
  List<ProductModel> _items = [];

  List<ProductModel> get items => [..._items];

  List<ProductModel> get favoritesItems =>
      _items.where((product) => product.isFavorite == true).toList();

  int get itemsCount {
    return _items.length;
  }

  ProductListModel(this._token, this._items);

  Future<void> saveProduct(Map<String, Object> data) {
    bool hasId = data['id'] != null;

    final product = ProductModel(
      id: hasId ? data['id'].toString() : Random().nextDouble().toString(),
      title: data['name'].toString(),
      description: data['description'].toString(),
      price: data['price'] as double,
      imageUrl: data['imageUrl'].toString(),
    );

    if (hasId) {
      return updateProduct(product);
    } else {
      return addProduct(product);
    }
  }

  Future<void> addProduct(ProductModel product) async {
    final response =
        await http.post(Uri.parse('${Constants.produtcsBaseUrl}.json'),
            body: jsonEncode({
              "name": product.title,
              "description": product.description,
              "price": product.price,
              "imageUrl": product.imageUrl,
              "isFavorite": product.isFavorite
            }));

    final id = jsonDecode(response.body)['name'];
    _items.add(ProductModel(
        id: id,
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        isFavorite: product.isFavorite));
    notifyListeners();
  }

  Future<void> updateProduct(ProductModel product) async {
    int index = _items.indexWhere((element) => element.id == product.id);

    if (index >= 0) {
      await http.patch(
          Uri.parse('${Constants.produtcsBaseUrl}/${product.id}.json'),
          body: jsonEncode({
            "name": product.title,
            "description": product.description,
            "price": product.price,
            "imageUrl": product.imageUrl
          }));

      _items[index] = product;
      notifyListeners();
    }
  }

  Future<void> loadProducts() async {
    _items.clear();

    final response = await http
        .get(Uri.parse('${Constants.produtcsBaseUrl}.json?auth=$_token'));
    if (response.body == 'null') return;

    Map<String, dynamic> data = jsonDecode(response.body);
    data.forEach((productId, productData) {
      _items.add(ProductModel(
          id: productId,
          title: productData['name'],
          description: productData['description'],
          price: productData['price'],
          imageUrl: productData['imageUrl'],
          isFavorite: productData['isFavorite']));
    });
    notifyListeners();
  }

  Future<void> removeProduct(ProductModel product) async {
    int index = _items.indexWhere((element) => element.id == product.id);

    if (index >= 0) {
      final product = _items[index];
      _items.remove(product);
      notifyListeners();

      final response = await http
          .delete(Uri.parse('${Constants.produtcsBaseUrl}/${product.id}.json'));

      if (response.statusCode >= 400) {
        _items.insert(index, product);
        notifyListeners();
        throw HttpException(
          msg: 'Could not delete product!',
          statusCode: response.statusCode,
        );
      }
    }
  }
}
