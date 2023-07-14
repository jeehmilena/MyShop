import 'package:flutter/material.dart';

import '../models/product_model.dart';

class ProductDetail extends StatelessWidget {
  ProductDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProductModel product = ModalRoute.of(context)?.settings.arguments as ProductModel;
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
    );
  }
}
