import 'package:flutter/material.dart';
import 'package:my_shop/models/product_list.dart';
import 'package:my_shop/presenter/product_detail.dart';
import 'package:my_shop/presenter/products_overview.dart';
import 'package:my_shop/utils/app_routes.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProductList(),
      child: MaterialApp(
        theme: ThemeData(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: Colors.green,
                  secondary: Colors.lightGreenAccent,
                ),
            fontFamily: 'Lato'),
        home: ProductsOverview(),
        routes: {
          AppRoutes.product_detail: (ctx) => ProductDetail(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
