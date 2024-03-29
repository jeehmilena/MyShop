import 'package:flutter/material.dart';
import 'package:my_shop/models/order_list_model.dart';
import 'package:provider/provider.dart';

import '../models/cart_model.dart';
import '../widgets/cart_item.dart';

class CartOverview extends StatelessWidget {
  const CartOverview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CartModel cart = Provider.of(context);
    final items = cart.items.values.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 25,
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total:',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Chip(
                    backgroundColor: Colors.pinkAccent,
                    label: Text(
                      'R\$${cart.totalAmountCart.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const Spacer(),
                  CartPurchaseButton(cart: cart),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (ctx, i) => CartItem(
                cartItem: items[i],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CartPurchaseButton extends StatefulWidget {
  const CartPurchaseButton({
    super.key,
    required this.cart,
  });

  final CartModel cart;

  @override
  State<CartPurchaseButton> createState() => _CartPurchaseButtonState();
}

class _CartPurchaseButtonState extends State<CartPurchaseButton> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const CircularProgressIndicator()
        : TextButton(
            onPressed: widget.cart.itemsCount == 0
                ? null
                : () async {
                    setState(() => isLoading = true);
                    await Provider.of<OrderListModel>(context, listen: false)
                        .addOrder(widget.cart);

                    widget.cart.clearCart();
                    setState(() => isLoading = false);
                  },
            child: const Text(
              'PURCHASE',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          );
  }
}
