import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:health_care/constants.dart';
import 'package:health_care/mainpage.dart';
import 'package:health_care/screens/signin_screen/signin_screen.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:health_care/provider/cart_provider.dart';

class Checkout extends StatefulWidget {
  const Checkout({super.key});
  static String screenroute = '/checkout';

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  late TextEditingController _controller;
  bool _isEditing = false;
  bool _isLoading = false;
  String formattedDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
  String formattedTime = DateFormat('HH:mm:ss').format(DateTime.now());

  String? _selectedPaymentMethod;
  final List<Map<String, dynamic>> _paymentMethods = [
    {'name': 'Thanh toán khi nhận hàng', 'iconPath': 'assets/images/cash.png'},
    {'name': 'Visa', 'iconPath': 'assets/images/visa.png'},
    {'name': 'MasterCard', 'iconPath': 'assets/images/card.png'},
    
  ];

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    loadAddress();
    _selectedPaymentMethod = _paymentMethods.first['name'];
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> loadAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userDataString = prefs.getString('user_data');
    if (userDataString != null) {
      Map<String, dynamic> userData = jsonDecode(userDataString);
      setState(() {
        _controller.text = userData['address'];
      });
    } else {
      Navigator.pushNamed(context, SignInScreen.routeName);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bạn chưa đăng nhập vào tài khoản')),
      );
    }
  }

  Future<void> orderCreate() async {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final cartItems = cartProvider.cartItems;
    final totalPrice = cartProvider.getTotalPrice();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userDataString = prefs.getString('user_data');
    String? token = prefs.getString('access_token');
    if (userDataString != null && token != null) {
      Map<String, dynamic> userData = jsonDecode(userDataString);
      final accessToken = token;
      final userId = userData['_id'];
      
      final url = Uri.parse('http://localhost:3001/api/order/create/$userId');
      final headers = {
        'Content-Type': 'application/json',
        'token': 'Bearer $accessToken',
      };

      final orderItems = cartItems
          .map((item) => {
                'name': item.name,
                'amount': item.quantity,
                'image': 'data:image/png;base64,${item.img}',
                'price': item.price,
                'product': item.id,
              })
          .toList();

      final newOrder = {
        'orderItems': orderItems,
        'fullName': userData['name'],
        'address': userData['address'],
        'city': userData['city'],
        'phone': userData['phone'],
        'paymentMethod': _selectedPaymentMethod,
        'itemsPrice': totalPrice,
        'shippingPrice': 30000,
        'totalPrice': totalPrice + 30000,
        'user': userId,
        'isPaid': false,
        'paidAt': DateTime.now().toIso8601String(),
        'email': userData['email']
      };

      final body = json.encode(newOrder);
      try {
        setState(() {
          _isLoading = true;
        });
        var response = await http.post(url, headers: headers, body: body);

        if (response.statusCode == 404) {
          String? newToken = await refreshToken();
          if (newToken != null) {
            response = await http.post(
              url,
              headers: {
                'token': 'Bearer $newToken',
                'Content-Type': 'application/json',
              },
              body: body,
            );
          }
        }

        if (response.statusCode == 200) {
          cartProvider.cartItems.clear();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Đặt hàng thành công')),
          );
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => Mainpage()),
            (Route<dynamic> route) => false,
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Đặt hàng thất bại: ${response.statusCode}')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<String?> refreshToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? refreshToken = prefs.getString('refresh_token');
    if (refreshToken == null) {
      return null;
    }

    final response = await http.post(
      Uri.parse('http://localhost:3001/api/user/refresh-token'),
      headers: {'token': 'Bearer $refreshToken'},
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = jsonDecode(response.body);
      String newAccessToken = responseData['access_token'];
      await prefs.setString('access_token', newAccessToken);
      return newAccessToken;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItems = cartProvider.cartItems;

    final formattedTotalPrice =
        NumberFormat.currency(locale: 'vi_VN', symbol: '₫')
            .format(cartProvider.getTotalPrice());
    final formattedTotalPriceShip =
        NumberFormat.currency(locale: 'vi_VN', symbol: '₫')
            .format(cartProvider.getTotalPrice() + 30000);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Checkout',
          style: TextStyle(fontSize: 20, color: black),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/loading.gif'),
                  const SizedBox(height: 16),
                  const Text(
                    'Đang xử lý...',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              child: Padding(
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
                        Text('Payment',
                            style: TextStyle(color: Colors.grey, fontSize: 18)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Địa chỉ giao hàng',
                            style: TextStyle(fontSize: 18)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _controller.text,
                      softWrap: true,
                      overflow: TextOverflow.visible,
                      style: const TextStyle(fontSize: 15),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Ngày', style: TextStyle(fontSize: 18)),
                        Text(formattedDate,
                            style: const TextStyle(fontSize: 18)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Giờ', style: TextStyle(fontSize: 18)),
                        Text(formattedTime,
                            style: const TextStyle(fontSize: 18)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 16),
                    const Text('Sản phẩm', style: TextStyle(fontSize: 18)),
                    const SizedBox(height: 16),
                    Container(
                      height: 200, // Adjust this height based on your layout
                      child: ListView.builder(
                        itemCount: cartItems.length,
                        itemBuilder: (context, index) {
                          final item = cartItems[index];
                          return ListTile(
                            leading: Image.memory(
                              base64Decode(item.img),
                              fit: BoxFit.cover,
                              width: 60,
                              height: 60,
                            ),
                            title: Text(item.name),
                            subtitle: Text(
                                'Số lượng: ${item.quantity} - Giá: ${NumberFormat.currency(locale: 'vi_VN', symbol: '₫').format(item.price)}'),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 16),
                    const Text('Phương thức thanh toán',
                        style: TextStyle(fontSize: 18)),
                    const SizedBox(height: 8),
                    ExpansionTile(
                      title: Text(
                        _selectedPaymentMethod ?? 'Chọn phương thức thanh toán',
                        style: const TextStyle(fontSize: 18),
                      ),
                      children: _paymentMethods.map((method) {
                        return ListTile(
                          leading: Image.asset(
                            method['iconPath'],
                            width: 40,
                            height: 40,
                          ),
                          title: Text(method['name'],
                              style: const TextStyle(fontSize: 18)),
                          onTap: () {
                            setState(() {
                              _selectedPaymentMethod = method['name'];
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Tổng giá trị sản phẩm',
                            style: TextStyle(fontSize: 18)),
                        Text(formattedTotalPrice,
                            style: const TextStyle(fontSize: 18)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Phí vận chuyển',
                            style: TextStyle(fontSize: 18)),
                        const Text('30,000 ₫',
                            style: TextStyle(fontSize: 18)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Tổng giá trị thanh toán',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        Text(formattedTotalPriceShip,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: orderCreate,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          backgroundColor: kPrimaryColor,
                        ),
                        child: const Text('Thanh toán ngay',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: white)),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
    );
  }
}
