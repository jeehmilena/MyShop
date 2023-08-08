import 'package:flutter/material.dart';
import 'package:my_shop/models/order_list_model.dart';
import 'package:my_shop/widgets/app_drawer.dart';
import 'package:my_shop/widgets/order_item.dart';
import 'package:provider/provider.dart';

class OrdersOverview extends StatelessWidget {
  const OrdersOverview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My orders'),
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future:
            Provider.of<OrderListModel>(context, listen: false).loadOrders(),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.error != null) {
            return const Center(
              child: Text('Oops! An error has occurred.!'),
            );
          } else {
            return Consumer<OrderListModel>(
              builder: (ctx, orders, child) => ListView.builder(
                itemCount: orders.itemsCount,
                itemBuilder: (ctx, i) => OrderItem(order: orders.items[i]),
              ),
            );
          }
        }),
      ),
    );
  }
}
