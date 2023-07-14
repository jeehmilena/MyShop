import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:my_shop/models/cart_model.dart';

import 'order_model.dart';

class OrderListModel with ChangeNotifier {
  final List<OrderModel> _items = [];

  List<OrderModel> get items {
    return [..._items];
  }

  int get itemsCount {
    return _items.length;
  }

  void addOrder(CartModel cart) {
    _items.insert(
      0,
      OrderModel(
        id: Random().nextDouble().toString(),
        total: cart.totalAmountCart,
        products: cart.items.values.toList(),
        date: DateTime.now(),
      ),
    );
    notifyListeners();
  }
}
