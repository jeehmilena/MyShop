import 'package:flutter/material.dart';
import 'package:my_shop/models/auth_model.dart';
import 'package:my_shop/models/cart_model.dart';
import 'package:my_shop/models/order_list_model.dart';
import 'package:my_shop/presenter/auth_page.dart';
import 'package:my_shop/presenter/cart_overview.dart';
import 'package:my_shop/presenter/form_product.dart';
import 'package:my_shop/presenter/manage_products.dart';
import 'package:my_shop/presenter/orders_overview.dart';
import 'package:my_shop/presenter/product_detail.dart';
import 'package:my_shop/presenter/products_overview.dart';
import 'package:my_shop/utils/app_routes.dart';
import 'package:provider/provider.dart';

import 'models/product_list_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductListModel()),
        ChangeNotifierProvider(create: (_) => CartModel()),
        ChangeNotifierProvider(create: (_) => OrderListModel()),
        ChangeNotifierProvider(create: (_) => AuthModel()),
      ],
      child: MaterialApp(
        theme: ThemeData(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: Colors.green,
                  secondary: Colors.lightGreenAccent,
                ),
            fontFamily: 'Lato'),
        routes: {
          AppRoutes.auth: (ctx) => const AuthPage(),
          AppRoutes.home: (ctx) => const ProductsOverview(),
          AppRoutes.productDetail: (ctx) => const ProductDetail(),
          AppRoutes.cart: (ctx) => const CartOverview(),
          AppRoutes.orders: (ctx) => const OrdersOverview(),
          AppRoutes.manageProducts: (ctx) => const ManageProducts(),
          AppRoutes.formProducts: (ctx) => const FormProduct(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
