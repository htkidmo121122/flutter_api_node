import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:health_care/constants.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; // Import thư viện intl

import '../../models/CartItem.dart';
import '../../provider/cart_provider.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem cartItem;
  final Function(String) onRemove;

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
    // Định dạng số tiền thành VND
    final formattedPrice = NumberFormat.currency(locale: 'vi_VN', symbol: '₫')
        .format(cartItem.price * cartItem.quantity);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: Container(
          // color: white,
           decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.9),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                     bottomRight: Radius.circular(10),
                    ),
                 ),
          child: Row(
            children: [
              Container(
                
                decoration: BoxDecoration(
                   color: Colors.pink.withOpacity(0.1),
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
                  child: Image.memory(
                    base64Decode(cartItem.img),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ), 
                  child: Container(   
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(cartItem.name, style: const TextStyle(fontSize: 18)),
                        const SizedBox(height: 5),
                        Text(
                          formattedPrice, style: const TextStyle( fontWeight: FontWeight.bold),
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
