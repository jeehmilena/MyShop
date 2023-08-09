import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:my_shop/models/cart_item_model.dart';
import 'package:my_shop/models/cart_model.dart';
import 'package:my_shop/utils/constants.dart';

import 'order_model.dart';

class OrderListModel with ChangeNotifier {
  final String _token;
  List<OrderModel> _items = [];

  OrderListModel([this._token = '', this._items = const []]);

  List<OrderModel> get items {
    return [..._items];
  }

  int get itemsCount {
    return _items.length;
  }

  Future<void> loadOrders() async {
    List<OrderModel> items = [];

    final response = await http
        .get(Uri.parse('${Constants.ordersBaseUrl}.json?auth=$_token'));
    if (response.body == 'null') return;

    Map<String, dynamic> data = jsonDecode(response.body);
    data.forEach((orderId, orderData) {
      items.add(OrderModel(
        id: orderId,
        total: orderData['total'],
        date: DateTime.parse(orderData['date']),
        products: (orderData['products'] as List<dynamic>).map((item) {
          return CartItemModel(
            id: item['id'],
            productId: item['productId'],
            title: item['name'],
            quantity: item['quantity'],
            price: item['price'],
          );
        }).toList(),
      ));
    });

    _items = items.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(CartModel cart) async {
    final date = DateTime.now();

    final response = await http.post(
        Uri.parse('${Constants.ordersBaseUrl}.json?auth=$_token'),
        body: jsonEncode({
          "total": cart.totalAmountCart,
          "date": date.toIso8601String(),
          "products": cart.items.values
              .map((cardItem) => {
                    "id": cardItem.id,
                    "productId": cardItem.productId,
                    "name": cardItem.title,
                    "quantity": cardItem.quantity,
                    "price": cardItem.price
                  })
              .toList(),
        }));

    final id = jsonDecode(response.body)['name'];

    _items.insert(
      0,
      OrderModel(
        id: id,
        total: cart.totalAmountCart,
        products: cart.items.values.toList(),
        date: date,
      ),
    );
    notifyListeners();
  }
}
