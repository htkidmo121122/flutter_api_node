import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:health_care/constants.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminOrdersScreen extends StatefulWidget {
  static String routeName = "/admin_orders";

  @override
  _AdminOrdersScreenState createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends State<AdminOrdersScreen> {
  List<Map<String, dynamic>> orders = [];
  bool _isProcessing = false; // Biến trạng thái để theo dõi thao tác đang thực hiện
  

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }
  //Fetch dữ liệu ban đầu 
  Future<void> fetchOrders() async {
    setState(() {
      _isProcessing = true; // Bắt đầu quá trình xử lý
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');
    if (token != null) {
      final accessToken = token;
      
      final url = Uri.parse('http://localhost:3001/api/order/get-all-order');
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
            _isProcessing= false;
          });
          
        } else {
          //Handle API response error
          print('Error: ${data['message']}');
        }
      } else {
        // Handle HTTP error
        print('HTTP Error: ${response.statusCode}');
      }
    }
  }

  Future<void> confirmDelivery(String orderId) async {
    setState(() {
    _isProcessing = true; // Bắt đầu quá trình xử lý
  });

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('access_token');
  if (token != null) {
    final accessToken = token;

    final url = Uri.parse('http://localhost:3001/api/order/confirm-delivery/$orderId');
    final headers = {
      'Content-Type': 'application/json',
      'token': 'Bearer $accessToken',
    };

    var response = await http.post(url, headers: headers);

    if (response.statusCode == 404) {
      String? newToken = await refreshToken();
      if (newToken != null) {
        response = await http.put(
          url,
          headers: {
            'token': 'Bearer $newToken',
            'Content-Type': 'application/json',
          },
        );
      }
    }

    setState(() {
      _isProcessing = false; // Kết thúc quá trình xử lý
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 'OK') {

        //Chỉnh sửa thông tin delivered realtime
        setState(() {
            // Update the local list of orders
            orders = orders.map((order) {
              if (order['_id'] == orderId) {
                return {...order, 'isDelivered': true};
              }
              return order;
            }).toList();
        });

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.white,
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Image.asset(
                    'assets/images/success.gif',
                    width: 100,
                    height: 100,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Thành Công',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            );
          },
        );
        // fetchOrders();
      } else {
        print('Error: ${data['message']}');
      }
    } else {
      print('HTTP Error: ${response.statusCode}');
    }
  }
}

  Future<void> deleteOrder(String orderId) async {
      setState(() {
        _isProcessing = true; // Bắt đầu quá trình xử lý
      });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');
    if (token != null) {
      final accessToken = token;

      final url = Uri.parse('http://localhost:3001/api/order/delete-order/$orderId');
      final headers = {
        'Content-Type': 'application/json',
        'token': 'Bearer $accessToken',
      };

      var response = await http.delete(url, headers: headers);

      if (response.statusCode == 404) {
        String? newToken = await refreshToken();
        if (newToken != null) {
          response = await http.delete(
            url,
            headers: {
              'token': 'Bearer $newToken',
              'Content-Type': 'application/json',
            },
          );
        }
      }

      setState(() {
        _isProcessing = false; // Kết thúc quá trình xử lý
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'OK') {
          setState(() {
            // Bỏ đơn hàng trong list order
            orders = orders.where((order) => order['_id'] != orderId).toList();
          });

          showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.white,
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Image.asset(
                    'assets/images/success.gif',
                    width: 100,
                    height: 100,
                  ),
                  SizedBox(height: 16),
                  const Text(
                    'Thành Công',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            );
          },
        );
          // fetchOrders();
        } else {
          print('Error: ${data['message']}');
        }
      } else {
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
        title: Text("Manage Order"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: _isProcessing
        ? Center(
              child: Image.asset(
                'assets/images/cartempty.gif',
                width: 100,
                height: 100,
              ),
            )
             : orders.isEmpty
            ? const Center(
                child: Text('Không có đơn hàng', style: TextStyle()),
              ): 
            ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                final shippingAddress = order['shippingAddress'];
                final orderItems = order['orderItems'] as List<dynamic>;
                final formattedTotalPrice =
                    NumberFormat.currency(locale: 'vi_VN', symbol: '₫')
                        .format(order['totalPrice']);
                final formattedShippingPrice =
                    NumberFormat.currency(locale: 'vi_VN', symbol: '₫')
                        .format(order['shippingPrice']);
                final formatteditemsPrice =
                    NumberFormat.currency(locale: 'vi_VN', symbol: '₫')
                        .format(order['itemsPrice']);
                return 
                Card(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  margin: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 8),
                        const Divider(),
                        const Text(
                          'Địa chỉ giao hàng:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${shippingAddress['fullName']}, ${shippingAddress['address']}, ${shippingAddress['city']}, Phone: ${shippingAddress['phone']}',
                        ),
                        const SizedBox(height: 8),
                         const Divider(),
                        const Text(
                          'Sản phẩm:',
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
                        Text('Hình Thức: ${order['paymentMethod']}'),
                        Text('Giá: ${formatteditemsPrice}'),
                        Text('Phí Ship: ${formattedShippingPrice}'),
                        Text('Tổng Tiền: ${formattedTotalPrice}'),
                        Text('Thanh Toán: ${order['isPaid'] ? "Đã Thanh Toán" : "Chưa Thanh Toán"}'),
                        Text('Giao Hàng: ${order['isDelivered'] ? "Đã Giao Hàng" : "Đang xử lý"}'),
                        
                        SizedBox(height: 8),
                        // Chưa Xác nhận giao hàng
                        if (!order['isDelivered'])
                          ElevatedButton(
                          onPressed: () {
                            confirmDelivery(order['_id']);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kPrimaryColor,
                            minimumSize: Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: const Text(
                            'Xác nhận giao hàng',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        //  Chưa Thanh toán, mà giao hàng rồi => hiển thị nút xác nhận đã thanh toán
                        if (!order['isPaid'] && order['isDelivered'])
                          ElevatedButton(
                             onPressed: () {
                              
                             },
                             style: ElevatedButton.styleFrom(
                               backgroundColor: Color.fromARGB(255, 219, 217, 92),
                               minimumSize: Size(double.infinity, 50),
                               shape: RoundedRectangleBorder(
                                 borderRadius: BorderRadius.circular(8.0),
                               ),
                             ),
                             child: const Text(
                               'Chờ Thanh Toán...',
                               style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                             ),
                           ),
                        // Thanh toán rồi, Giao hàng rồi => Hiển thị nút xoá đơn hàng 
                        if (order['isPaid'] && order['isDelivered'])
                          ElevatedButton(
                          onPressed: () {
                            deleteOrder(order['_id']);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                            minimumSize: Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: const Text(
                            'Xoá Đơn Hàng',
                            style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const Divider(),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
