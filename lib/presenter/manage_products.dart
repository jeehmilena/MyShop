import 'package:flutter/material.dart';
import 'package:my_shop/models/product_list_model.dart';
import 'package:my_shop/widgets/app_drawer.dart';
import 'package:provider/provider.dart';

class ManageProducts extends StatelessWidget {
  const ManageProducts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProductListModel products = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Products'),
      ),
      drawer: const AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: ListView.builder(
          itemCount: products.itemsCount,
          itemBuilder: (ctx, index) => Text(products.items[index].title),
        ),
      ),
    );
  }
}
