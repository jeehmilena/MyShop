import 'package:flutter/material.dart';
import 'package:my_shop/models/product_list_model.dart';
import 'package:my_shop/utils/app_routes.dart';
import 'package:my_shop/widgets/app_drawer.dart';
import 'package:my_shop/widgets/cart_badge.dart';
import 'package:my_shop/widgets/product_grid.dart';
import 'package:provider/provider.dart';

import '../models/cart_model.dart';

enum FilterOptions {
  showFavorites,
  showAll,
}

class ProductsOverview extends StatefulWidget {
  const ProductsOverview({Key? key}) : super(key: key);

  @override
  State<ProductsOverview> createState() => _ProductsOverviewState();
}

class _ProductsOverviewState extends State<ProductsOverview> {
  bool _showFavoritesOnly = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    Provider.of<ProductListModel>(
      context,
      listen: false,
    ).loadProducts().then((value) {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Shop'),
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.list),
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: FilterOptions.showFavorites,
                child: Text('Show only favorites'),
              ),
              const PopupMenuItem(
                value: FilterOptions.showAll,
                child: Text('Show all'),
              ),
            ],
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.showFavorites) {
                  _showFavoritesOnly = true;
                } else {
                  _showFavoritesOnly = false;
                }
              });
            },
          ),
          Consumer<CartModel>(
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.cart);
              },
              icon: const Icon(Icons.shopping_cart),
            ),
            builder: (ctx, cart, child) => CartBadge(
              value: cart.itemsCount.toString(),
              color: Colors.pinkAccent,
              child: child!,
            ),
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ProductGrid(showFavoritesOnly: _showFavoritesOnly),
      drawer: const AppDrawer(),
    );
  }
}
