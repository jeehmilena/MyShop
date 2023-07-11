import 'package:flutter/material.dart';
import 'package:my_shop/datasource/dummy_data.dart';
import 'package:my_shop/widgets/product_item.dart';

import '../models/product.dart';

class ProductsOverview extends StatelessWidget {
  final List<Product> loadedProducts = dummyProducts;

  ProductsOverview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Shop'),
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(10),
        itemCount: loadedProducts.length,
        itemBuilder: (ctx, index) => ProductItem(product: loadedProducts[index]),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
      ),
    );
  }
}
