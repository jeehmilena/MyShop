import 'package:flutter/material.dart';
import 'package:my_shop/widgets/product_grid_item.dart';
import 'package:provider/provider.dart';

import '../models/product_list_model.dart';
import '../models/product_model.dart';

class ProductGrid extends StatelessWidget {
  final bool showFavoritesOnly;

  const ProductGrid({Key? key, required this.showFavoritesOnly}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductListModel>(context);
    final List<ProductModel> loadedProducts =
        showFavoritesOnly == true ? provider.favoritesItems : provider.items;

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: loadedProducts.length,
      itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
        value: loadedProducts[index],
        child: const ProductGridItem(),
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
