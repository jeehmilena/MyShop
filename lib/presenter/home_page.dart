import 'package:flutter/material.dart';
import 'package:my_shop/models/auth_model.dart';
import 'package:my_shop/presenter/auth_page.dart';
import 'package:my_shop/presenter/products_overview.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    AuthModel auth = Provider.of(context);
    return auth.isAuth ? const ProductsOverview() : const AuthPage();
  }
}
