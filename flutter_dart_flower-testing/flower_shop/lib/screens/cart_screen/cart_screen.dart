import 'package:flutter/material.dart';
import 'package:health_care/constants.dart';
import 'package:health_care/mainpage.dart';
import 'package:health_care/models/CartItem.dart';
import 'package:health_care/screens/cart_screen/cart_item_widget.dart';
import 'package:health_care/screens/cart_screen/cart_provider.dart';
import 'package:provider/provider.dart';


class CartScreen extends StatefulWidget {
   static String routeName = "/cart";

  const CartScreen({super.key});
  
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItems = cartProvider.cartItems;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Shopping Cart"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushNamed(Mainpage.routeName);
          },
        ),
        backgroundColor: Colors.white

      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final cartItem = cartItems[index];
                return CartItemWidget(
                  cartItem: cartItem,
                  onRemove: (id) {
                    cartProvider.removeFromCart(id);
                  },
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Tổng cộng:',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '\$${cartProvider.getTotalPrice().toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Thêm logic thanh toán tại đây
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Thanh Toán'),
                        content: const Text('Cảm ơn bạn đã mua hàng!'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Đóng'),
                          ),
                        ],
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: black,
                  ),
                  child: const Text(
                    'Thanh Toán',
                    style: TextStyle(
                      color: white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16

                    ),
                    ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}