import 'package:flutter/material.dart';
import 'package:my_shop/models/cart.dart';
import 'package:my_shop/presenter/product_detail.dart';
import 'package:my_shop/presenter/products_overview.dart';
import 'package:my_shop/utils/app_routes.dart';
import 'package:provider/provider.dart';

import 'models/product_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductList()),
        ChangeNotifierProvider(create: (_) => Cart()),
      ],
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
