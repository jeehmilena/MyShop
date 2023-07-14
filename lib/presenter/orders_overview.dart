import 'package:flutter/material.dart';
import 'package:my_shop/models/order_list_model.dart';
import 'package:my_shop/widgets/app_drawer.dart';
import 'package:my_shop/widgets/order_item.dart';
import 'package:provider/provider.dart';

class OrdersOverview extends StatelessWidget {
  const OrdersOverview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final OrderListModel orders = Provider.of(context);

    return Scaffold(
        appBar: AppBar(
          title: const Text('My orders'),
        ),
        drawer: const AppDrawer(),
        body: ListView.builder(
          itemCount: orders.itemsCount,
          itemBuilder: (ctx, index) => OrderItem(order: orders.items[index]),
        ));
  }
}
