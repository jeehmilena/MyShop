import 'package:flutter/material.dart';

import '../models/product_model.dart';

class ProductDetail extends StatelessWidget {
  const ProductDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProductModel product =
        ModalRoute.of(context)?.settings.arguments as ProductModel;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                product.title,
                textAlign: TextAlign.center,
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: product.id,
                    child: Image.network(
                      product.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                      begin: Alignment(0, 0.8),
                      end: Alignment(0, 0),
                      colors: [
                        Color.fromRGBO(0, 0, 0, 0.7),
                        Color.fromRGBO(0, 0, 0, 0),
                      ],
                    )),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              // Container(
              //   color: Colors.pinkAccent,
              //   width: double.infinity,
              //   child: Padding(
              //     padding: const EdgeInsets.all(16),
              //     child: Text(
              //       product.title,
              //       style: Theme.of(context).textTheme.titleLarge?.copyWith(
              //             color: Colors.white,
              //           ),
              //       textAlign: TextAlign.center,
              //     ),
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 26, right: 18, left: 18, bottom: 26),
                child: Text(
                  product.description,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: Colors.grey.shade600),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 30,
                ),
                width: double.infinity,
                child: Text(
                  'Price: R\$${product.price.toStringAsFixed(2)}',
                  textAlign: TextAlign.end,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
