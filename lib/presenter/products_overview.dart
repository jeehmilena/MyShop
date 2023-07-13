import 'package:flutter/material.dart';
import 'package:my_shop/widgets/product_grid.dart';

class ProductsOverview extends StatelessWidget {
  const ProductsOverview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Shop'),
      ),
      body: const ProductGrid(),
    );
  }
}
