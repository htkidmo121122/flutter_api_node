import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_paypal_checkout/flutter_paypal_checkout.dart';
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
  String? _iconPath;
  
  final List<Map<String, dynamic>> _paymentMethods = [
    {'name': 'Thanh toán khi nhận hàng', 'iconPath': 'assets/images/cash.png'},
    {'name': 'PayPal', 'iconPath': 'assets/images/paypal.png'}
    
  ];

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    loadAddress();
    _selectedPaymentMethod = _paymentMethods.first['name'];
    _iconPath = _paymentMethods.first['iconPath'];
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
        SnackBar(content: Text('Bạn chưa đăng nhập vào tài khoản', style: TextStyle(color: Theme.of(context).scaffoldBackgroundColor),)),
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

      print(_selectedPaymentMethod);
      // Determine the payment status based on the selected payment method
      bool isPaid =  _selectedPaymentMethod == 'PayPal';
      int shippingFee = calculateShippingFee(totalPrice);

      final newOrder = {
        'orderItems': orderItems,
        'fullName': userData['name'],
        'address': userData['address'],
        'city': userData['city'],
        'phone': userData['phone'],
        'paymentMethod': _selectedPaymentMethod,
        'itemsPrice': totalPrice,
        'shippingPrice': shippingFee,
        'totalPrice': totalPrice + shippingFee,
        'user': userId,
        'isPaid': isPaid,
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
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => Mainpage()),
            (Route<dynamic> route) => false,
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
              children: [
                SizedBox(
                  width: 50,
                  height: 50,
                  child: Image.asset('assets/images/ordersuccess.gif'), // Path to your GIF
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Text(
                    'Đặt Hàng Thành Công',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            ),
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

  void _handlePayment() {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    ////////
    final shippingFee = calculateShippingFee(cartProvider.getTotalPrice());
    final totalPriceInUSD = cartProvider.getTotalPriceInUSD().toStringAsFixed(2);
 
    final shippingFeeInUSD = (shippingFee / 24000).toStringAsFixed(2);
    double total = double.parse(totalPriceInUSD) + double.parse(shippingFeeInUSD);
    final totalprice = total.toStringAsFixed(2);
    //////////////
    print(cartProvider.cartItems.map((item) {
                  return {
                    "name": item.name,
                    "quantity": item.quantity,
                    "price": '${(item.price/24000.00)}',
                    "currency": "USD"
                  };
                }).toList());
    print(totalPriceInUSD);
    print(shippingFeeInUSD);
    print(totalprice);
    /////////////////////
    if (_selectedPaymentMethod == 'PayPal') {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => PaypalCheckout(
          sandboxMode: true,
          clientId: "AY-EFxNB0HYWVdAuXrb_Lp5GTTB6OeOTFpI9qREX7dw9iK_p3xVWAoZOlQy5fXZH86-9Nw2olN-nCz2x",
          secretKey: "EIvbsEiOhp2jx2WyPGnjLpH1skd80fChSEQICy77cKIAqBI5QeEGl_BTmTyrcqfyx_S2I7tpbCuOdz1r",
          returnURL: "success.snippetcoder.com",
          cancelURL: "cancel.snippetcoder.com",
          transactions: [
            {
              "amount": {
                "total": totalprice,// Lấy theo giá dollar
                "currency": "USD",
                "details": {
                  "subtotal": '${totalPriceInUSD}',
                  "shipping": '${shippingFeeInUSD}',
                  "shipping_discount": 0
                }
              },
              "description": "Order payment.",
              
              //   "item_list": {
              //     "items": cartProvider.cartItems.map((item) {
              //       return {
              //         "name": item.name,
              //         "quantity": item.quantity,
              //         "price": '${(item.price/24000.00)}',
              //         "currency": "USD"
              //       };
              //     }).toList()
              //   }
            }
          ],
          note: "Contact us for any questions on your order.",
          onSuccess: (Map params) async {
            print("onSuccess: $params");
            await orderCreate();
          },
          onError: (error) {
            print("onError: $error");
            Navigator.pop(context);
          },
          onCancel: () {
            print('cancelled:');
            Navigator.pop(context);
          },
        ),
      ));
    } else {
      orderCreate();
    }
  }

  int calculateShippingFee(double totalPrice) {
    if (totalPrice > 5000000) {
      return 50000; // Free shipping for orders over 5,000,000 VND
    } else if (totalPrice > 2000000) {
      return 150000; // 150,000 VND shipping fee for orders over 2000,000 VND
    } else {
      return 250000; // Default shipping fee for other orders
    }
  }


  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItems = cartProvider.cartItems;

    final totalPrice = cartProvider.getTotalPrice();
    final shippingFee = calculateShippingFee(totalPrice);
    final totalPriceWithShipping = totalPrice + shippingFee;

    final formattedTotalPrice =
        NumberFormat.currency(locale: 'vi_VN', symbol: '₫')
            .format(totalPrice);
    final formattedShippingFee =
        NumberFormat.currency(locale: 'vi_VN', symbol: '₫')
            .format(shippingFee);
    final formattedTotalPriceShip = NumberFormat.currency(locale: 'vi_VN', symbol: '₫').format(totalPriceWithShipping);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        leading: _isLoading ? Container() : 
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        title: const Text(
          'Thanh Toán',
          
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
                    'Đang xác nhận...',
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
                        Text('Giao Hàng',
                            style: TextStyle(fontSize: 18, color: Colors.pink)),
                        SizedBox(width: 16),
                        Icon(Icons.play_arrow, color: Colors.grey),
                        Text('Thanh Toán',
                            style: TextStyle(color: Colors.grey, fontSize: 18)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Địa Chỉ Giao Hàng',
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
                    const Text('Sản phẩm:', style: TextStyle(fontSize: 18)),
                    const SizedBox(height: 10),
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
                      leading: Image.asset(
                            _iconPath ?? 'assets/images/cash.png',
                            width: 40,
                            height: 40,
                          ), 
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
                              style: const TextStyle(fontSize: 18, color: black)),
                          onTap: () {
                            setState(() {
                              _selectedPaymentMethod = method['name'];
                              _iconPath = method['iconPath'];
                              
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
                        Text(formattedShippingFee,
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
                    if (_selectedPaymentMethod == 'PayPal') 
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _handlePayment,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          backgroundColor: const Color.fromARGB(255, 255, 194, 11),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/paypal.gif', // Ensure the path is correct
                              width: 50,
                              height: 24,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Pay with PayPal',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 12, 22, 207),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (_selectedPaymentMethod != 'PayPal') 
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _handlePayment,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          backgroundColor: kPrimaryColor,
                        ),
                        child: const Text('Thanh Toán',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
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
