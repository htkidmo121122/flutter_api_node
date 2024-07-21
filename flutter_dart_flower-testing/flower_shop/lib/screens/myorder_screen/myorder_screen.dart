import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:health_care/constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MyOrdersScreen extends StatefulWidget {
  static String routeName = "/my_orders";

  @override
  _MyOrdersScreenState createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  List<Map<String, dynamic>> orders = [];

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userDataString = prefs.getString('user_data');
    String? token = prefs.getString('access_token');
    if (userDataString != null && token != null) {
      Map<String, dynamic> userData = jsonDecode(userDataString);
      final accessToken = token;
      final userId = userData['_id'];
      
      final url = Uri.parse('http://localhost:3001/api/order/get-all-order/$userId');
      final headers = {
        'Content-Type': 'application/json',
        'token': 'Bearer $accessToken',
      };

      var response = await http.get(url, headers: headers);

      if (response.statusCode == 404) {
          String? newToken = await refreshToken();
          if (newToken != null) {
            response = await http.get(
              url,
              headers: {
                'token': 'Bearer $newToken',
                'Content-Type': 'application/json',
              },
            );
          }
        }
    

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'OK') {
          setState(() {
            orders = List<Map<String, dynamic>>.from(data['data']);
          });
        } else {
          // Handle API response error
          print('Error: ${data['message']}');
        }
      } else {
        // Handle HTTP error
        print('HTTP Error: ${response.statusCode}');
      }
    }
  }

  Future<void> cancelOrder(String orderId, List<dynamic> orderItems) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');
    String? userDataString = prefs.getString('user_data');
    if (userDataString != null && token != null) {
      Map<String, dynamic> userData = jsonDecode(userDataString);
      final accessToken = token;
      final userId = userData['_id'];

    final url = Uri.parse('http://localhost:3001/api/order/cancel-order/$userId');
    final headers = {
      'Content-Type': 'application/json',
      'token': 'Bearer $accessToken',
      
    };

    final body = jsonEncode({
      'orderId': orderId,
      'orderItems': orderItems,
    });

    var response = await http.delete(url, headers: headers, body: body,);
    print(response.body);

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
      final data = jsonDecode(response.body);
      if (data['status'] == 'OK') {
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
                                    'assets/images/success.gif', // Thay đổi đường dẫn tới file GIF của bạn
                                    width: 100, // Điều chỉnh kích thước phù hợp
                                    height: 100, // Điều chỉnh kích thước phù hợp
                                  ),
                                  SizedBox(height: 16), // Khoảng cách giữa GIF và văn bản
                                  const Text('Success', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: black),),
                                ],
                                
                              
                              ),
                            );
                          },
                        );
                        Future.delayed(Duration(seconds: 2), () {
                          fetchOrders();
                          Navigator.of(context, rootNavigator: true).pop();
                         
                        });
        
      } else {
        // Handle API response error
        print('Error: ${data['message']}');
      }
    } else {
      // Handle HTTP error
      print('HTTP Error: ${response.statusCode}');
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
    return Scaffold(
      appBar: AppBar(
        title: Text("My Orders"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: orders.isEmpty
          ? Center(
              child: Image.asset(
                'assets/images/cartempty.gif',
                width: 100,
                height: 100,
              ),
            )
          : ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                final shippingAddress = order['shippingAddress'];
                final orderItems = order['orderItems'] as List<dynamic>;
              
                return 
                Card(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  margin: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 8),
                        const Text(
                          'Shipping Address:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${shippingAddress['fullName']}, ${shippingAddress['address']}, ${shippingAddress['city']}, Phone: ${shippingAddress['phone']}',
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Order Items:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),

                        ...orderItems.map((item) {
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: Image.memory(
                              base64Decode(item['image'].split(',').last),
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                            title: Text(item['name']),
                            subtitle: Text('Quantity: ${item['amount']}'),
                            trailing: Text('${item['price']} VND'),
                          );
                        }).toList(),
                        const Divider(),
                        Text('Payment Method: ${order['paymentMethod']}'),
                        Text('Items Price: ${order['itemsPrice']} VND'),
                        Text('Shipping Price: ${order['shippingPrice']} VND'),
                        Text('Total Price: ${order['totalPrice']} VND'),
                        Text('Paid: ${order['isPaid'] ? "Đã Thanh Toán" : "Chưa Thanh Toán"}'),
                        SizedBox(height: 8),
                        if (!order['isPaid'])
                          ElevatedButton(
                            onPressed: () {
                              cancelOrder(order['_id'], order['orderItems']);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              minimumSize: Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            child: const Text(
                              'Cancel Order',
                              style: TextStyle(fontSize: 18, color: white, fontWeight: FontWeight.bold),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
