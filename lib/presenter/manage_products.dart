import 'package:flutter/material.dart';
import 'package:my_shop/models/product_list_model.dart';
import 'package:my_shop/utils/app_routes.dart';
import 'package:my_shop/widgets/app_drawer.dart';
import 'package:my_shop/widgets/product_item.dart';
import 'package:provider/provider.dart';

class ManageProducts extends StatelessWidget {
  const ManageProducts({Key? key}) : super(key: key);

  Future<void> refreshProducts(BuildContext context) {
    return Provider.of<ProductListModel>(
      context,
      listen: false,
    ).loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    final ProductListModel products = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
          title: const Text(
            'Manage Products',
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.formProducts);
              },
              icon: const Icon(Icons.add),
            ),
          ]),
      drawer: const AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => refreshProducts(context),
        child: Padding(
          padding: const EdgeInsets.only(top: 8, right: 8, left: 8, bottom: 42),
          child: ListView.builder(
            itemCount: products.itemsCount,
            itemBuilder: (ctx, index) => Column(
              children: [
                ProductItem(
                  product: products.items[index],
                ),
                const Divider(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(AppRoutes.formProducts);
        },
        backgroundColor: Colors.green,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
