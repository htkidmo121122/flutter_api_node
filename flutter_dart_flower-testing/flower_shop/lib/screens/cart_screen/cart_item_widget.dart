import 'package:flutter/material.dart';
import 'package:health_care/constants.dart';
import 'package:provider/provider.dart';

import '../../models/CartItem.dart';
import '../cart_screen/cart_provider.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem cartItem;
  final Function(int) onRemove;

  const CartItemWidget({
    Key? key,
    required this.cartItem,
    required this.onRemove,
  }) : super(key: key);

  void _increaseQuantity(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    cartProvider.updateQuantity(cartItem.id, cartItem.quantity + 1);
  }

  void _decreaseQuantity(BuildContext context) {
    if (cartItem.quantity > 1) {
      final cartProvider = Provider.of<CartProvider>(context, listen: false);
      cartProvider.updateQuantity(cartItem.id, cartItem.quantity - 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: Container(
          color: Colors.white,
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.black12.withOpacity(0.1),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  ),
                ),
                width: 140,
                height: 140,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  ),
                  child: Image.asset(
                    cartItem.img,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 1,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(cartItem.name, style: const TextStyle(fontSize: 18)),
                        const SizedBox(height: 5),
                        Text(
                          "\$${(cartItem.price * cartItem.quantity).toStringAsFixed(2)}",
                        ),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 1,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: SizedBox(
                                    width: 35,
                                    child: IconButton(
                                      iconSize: 20,
                                      icon: const Icon(Icons.remove_circle_outline),
                                      onPressed: () => _decreaseQuantity(context),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(cartItem.quantity.toString(), style: const TextStyle(fontSize: 18)),
                                const SizedBox(width: 10),
                                Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 1,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: SizedBox(
                                    width: 35,
                                    child: IconButton(
                                      iconSize: 20,
                                      icon: const Icon(Icons.add_circle_outline),
                                      onPressed: () => _increaseQuantity(context),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                onRemove(cartItem.id);
                              },
                              color: kSecondaryColor,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
