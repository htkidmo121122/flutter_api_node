import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:health_care/constants.dart';
import 'package:health_care/screens/cart_screen/cart_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

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

  //xử lý đơn hàng
  Future<void> ordercreate() async {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final cartItems = cartProvider.cartItems;
    final totalPrice = cartProvider.getTotalPrice();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userDataString = prefs.getString('user_data');
    String? token = prefs.getString('access_token');
    if (userDataString != null || token != null) {
      Map<String, dynamic> userData = jsonDecode(userDataString!);
      final accessToken = token;
      final userId = userData['_id'];

      final url = Uri.parse('http://10.0.2.2:3001/api/order/create/${userId}');
      final headers = {
        'Content-Type': 'application/json',
        'token': 'Bearer $accessToken ', // Thay thế bằng token thực tế nếu cần
      };

      // Tạo dữ liệu đơn hàng từ cartItems
      final orderItems = cartItems
          .map((item) => {
                'name': item.name,
                'amount': item.quantity,
                'image': item.img,
                'price': item.price,
                'product': item.id, // Assuming this is the product ID
              })
          .toList();

      print(userData['name']);

      final newOrder = {
        'orderItems': orderItems,
        'fullName':
            userData['name'], // Thay thế bằng thông tin người dùng thực tế
        'address': userData['address'],
        'city': userData['city'], // Thay thế bằng thông tin thực tế
        'phone': userData['phone'], // Thay thế bằng thông tin thực tế
        'paymentMethod':
            'Thanh toán khi nhận hàng', // Thay thế bằng phương thức thanh toán thực tế
        'itemsPrice': totalPrice,
        'shippingPrice': 30000, // Phí vận chuyển
        'totalPrice': totalPrice + 30000, // Tổng giá
        'user': userId, // Thay thế bằng thông tin thực tế
        'isPaid': false, // Chỉnh sửa theo trạng thái thanh toán thực tế
        'paidAt': DateTime.now().toIso8601String(),
        'email': userData['email']
      }; // encode thành file json

      final body = json.encode(newOrder);
      try {
        var response = await http.post(url, headers: headers, body: body);

        if (response.statusCode == 404) {
          // Token hết hạn, refresh token và thử lại
          String? newToken = await refreshToken(); // lấy token mới
          if (newToken != null) {
            /////Gọi api lại với token mới
            response = await http.post(
              url,
              headers: <String, String>{
                'token': 'Bearer $newToken',
                'Content-Type': 'application/json',
              },
              body: body,
            );
          }
        }
        print(response.body);

        if (response.statusCode == 200) {
          // Xử lý phản hồi nếu đơn hàng được tạo thành công
          print('Order created successfully');
        } else {
          // Xử lý lỗi nếu đơn hàng không được tạo thành công
          print('Failed to create order: ${response.statusCode}');
        }
      } catch (e) {
        // Xử lý lỗi khi gửi yêu cầu HTTP
        print('Error: $e');
      }
    }
  }

  //hàm lấy token mới khi token cũ hết han
  Future<String?> refreshToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? refreshToken = prefs.getString('refresh_token');
    if (refreshToken == null) {
      // Không có refresh token
      return null;
    }

    final response = await http.post(
      Uri.parse(
          'http://10.0.2.2:3001/api/user/refresh-token'), // Thay URL bằng URL API thực tế của bạn
      headers: <String, String>{
        'token': 'Bearer $refreshToken',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = jsonDecode(response.body);
      String newAccessToken = responseData['access_token'];
      await prefs.setString('access_token', newAccessToken);
      return newAccessToken;
    } else {
      // Xử lý lỗi
      return null;
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
                  // TextButton(
                  //     onPressed: () {
                  //       setState(() {
                  //         _isEditing = !_isEditing;
                  //       });
                  //     },
                  //     child: Text(_isEditing ? 'Save' : 'Edit'))
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
              const SizedBox(height: 12),
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
              const SizedBox(height: 12),
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
              const Spacer(),
              const SizedBox(
                height: 16,
              ),
              SizedBox(
                width: MediaQuery.of(context)
                    .size
                    .width, // Chiều rộng của màn hình
                child: ElevatedButton(
                  onPressed: ordercreate,
                  child: const Text('Thanh toán'),
                ),
              )
            ],
          ),
        ));
  }
}
