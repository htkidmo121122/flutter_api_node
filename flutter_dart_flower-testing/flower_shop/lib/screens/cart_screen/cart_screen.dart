import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:health_care/constants.dart';
import 'package:health_care/mainpage.dart';
import 'package:health_care/screens/checkout/checkout.dart';
import 'package:intl/intl.dart'; // Import thư viện intl

import 'package:health_care/screens/cart_screen/cart_item_widget.dart';
import 'package:health_care/provider/cart_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartScreen extends StatefulWidget {
  static String routeName = "/cart";

  const CartScreen({super.key});
  
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  Future<bool> _checkUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userDataString = prefs.getString('user_data');
    
    if (userDataString != null) {
      Map<String, dynamic> userData = jsonDecode(userDataString);
      // Kiểm tra các thông tin cần thiết
      return userData['name'] != null && userData['address'] != null && userData['city'] != null && userData['phone'] != null;
    }
    
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItems = cartProvider.cartItems;

    // Định dạng tổng tiền thành VND
    final formattedTotalPrice = NumberFormat.currency(locale: 'vi_VN', symbol: '₫')
        .format(cartProvider.getTotalPrice());

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
                      formattedTotalPrice,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (cartItems.isNotEmpty) {
                      bool hasCompleteInfo = await _checkUserInfo();
                      if (hasCompleteInfo) {
                        // Điều hướng đến trang thanh toán
                        Navigator.of(context).pushNamed(Checkout.screenroute);
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              backgroundColor: Colors.white, // Nền của AlertDialog
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  // Hiển thị file GIF ở phía trên
                                  Image.asset(
                                    'assets/images/noinfo.gif', // Thay đổi đường dẫn tới file GIF của bạn
                                    width: 100, // Điều chỉnh kích thước phù hợp
                                    height: 100, // Điều chỉnh kích thước phù hợp
                                  ),
                                  SizedBox(height: 16), // Khoảng cách giữa GIF và văn bản
                                  const Text('Vui lòng cập nhật đầy đủ thông tin cá nhân trước khi đặt hàng.', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                                ],
                                
                              
                              ),
                            );
                          },
                        );
                        Future.delayed(Duration(seconds: 2), () {
                          Navigator.of(context, rootNavigator: true).pop();
                        });
                      }
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: Colors.white, // Nền của AlertDialog
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                // Hiển thị file GIF ở phía trên
                                Image.asset(
                                  'assets/images/cartempty.gif', // Thay đổi đường dẫn tới file GIF của bạn
                                  width: 100, // Điều chỉnh kích thước phù hợp
                                  height: 100, // Điều chỉnh kích thước phù hợp
                                ),
                                SizedBox(height: 16), // Khoảng cách giữa GIF và văn bản
                                const Text('Giỏ hàng trống', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                              ],
                            ),
                          );
                        },
                      );
                      Future.delayed(Duration(seconds: 2), () {
                          Navigator.of(context, rootNavigator: true).pop();
                        });
                    }
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                  ),
                  child: const Text(
                    'Đặt Hàng',
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
