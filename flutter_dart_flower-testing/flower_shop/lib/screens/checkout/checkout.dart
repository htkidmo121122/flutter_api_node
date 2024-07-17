import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:health_care/constants.dart';
import 'package:health_care/screens/cart_screen/cart_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Checkout extends StatefulWidget {
  const Checkout({super.key});
  static String screenroute = '/checkout';
  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  late TextEditingController _controller;
  bool _isEditing = false;
  String formmattedDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
  String formattedTime = DateFormat('HH:mm:ss').format(DateTime.now());

  Future<void> loadaddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userDataString = prefs.getString('user_data');
    if (userDataString != null) {
      Map<String, dynamic> userData = jsonDecode(userDataString);
      setState(() {
        _controller.text = userData['address'];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(); // Initialize the controller
    loadaddress();
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose of the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItems = cartProvider.cartItems;

    final formattedTotalPrice =
        NumberFormat.currency(locale: 'vi_VN', symbol: '₫')
            .format(cartProvider.getTotalPrice());

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context)),
          title: const Text(
            'Checkout',
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: black),
          ),
          centerTitle: true,
        ),
        body: Container(
          color: white,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 8),
                  Icon(Icons.play_arrow, color: Colors.pink),
                  Text('Delivery',
                      style: TextStyle(fontSize: 18, color: Colors.pink)),
                  SizedBox(width: 16),
                  Icon(Icons.play_arrow, color: Colors.grey),
                  Text('Payment', style: TextStyle(color: Colors.grey)),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Delivery address'),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          _isEditing = !_isEditing;
                        });
                      },
                      child: Text(_isEditing ? 'Save' : 'Edit'))
                ],
              ),
              if (_isEditing)
                TextField(
                  controller: _controller,
                )
              else
                Text(_controller.text,
                    softWrap: true,
                    overflow: TextOverflow.visible,
                    style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 16),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text('date', style: TextStyle(fontSize: 18)),
                Text(formmattedDate, style: const TextStyle(fontSize: 18)),
              ]),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Time', style: TextStyle(fontSize: 18)),
                  Text(formattedTime, style: const TextStyle(fontSize: 18)),
                ],
              ),
              Container(
                color: Colors.purple[50],
                padding: const EdgeInsets.all(8),
                height: 150, // Adjust height as needed
                child: ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final item = cartItems[index];
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(item.name),
                        Text(
                            '\$${NumberFormat.currency(locale: 'vi_VN', symbol: '₫').format(item.price * item.quantity)}'),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Subtotal'),
                  Text(
                    formattedTotalPrice,
                  ),
                ],
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Delivery'),
                  Text('\$3'),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(
                    formattedTotalPrice,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
