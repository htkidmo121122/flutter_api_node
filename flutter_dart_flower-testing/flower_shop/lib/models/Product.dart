import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Product {
  final String id;
  final String title, description;
  final String images;
  final int rating;
  final double price;
  final String category;
  final int? discount;
  final int countInStock;
  final int? selled;

  Product(
      {required this.id,
      required this.images,
      required this.rating,
      required this.title,
      required this.price,
      required this.description,
      required this.category,
      this.discount,
      required this.countInStock,
      this.selled});

  factory Product.fromJson(Map<String, dynamic> json) {
    String base64Image = json['image'].split(',').last;
    return Product(
        id: json['_id'],
        images: base64Image,
        title: json['name'],
        price: json['price'].toDouble(),
        description: json['description'],
        rating: json['rating'] ?? 0,
        category: json['type'],
        discount: json['discount'] ?? 0,
        countInStock: json['countInStock'] ?? 0,
        selled: json['selled'] ?? 0);
  }
}

List<Product> demoProducts = [];

// Future<void> fetchProducts(BuildContext context) async {
//   try {
//   final prefs = await SharedPreferences.getInstance();
//   final cachedData = prefs.getString('products');
//   final currentTime = DateTime.now().millisecondsSinceEpoch;
//   final lastFetchTime = prefs.getInt('lastFetchTime') ?? 0;

//   // Nếu chưa đủ 1 phút (60 milliseconds) kể từ lần cập nhật cuối cùng, sử dụng dữ liệu cache
//   if (currentTime - lastFetchTime < 30 && cachedData != null) {
    
//       demoProducts = (json.decode(cachedData) as List)
//           .map((json) => Product.fromJson(json))
//           .toList();
//       return;
//   }
//   else{
//     // Cập nhật dữ liệu từ server nếu đã đủ 1 giờ hoặc không có dữ liệu cache
//     final response = await http.get(Uri.parse('http://localhost:3001/api/product/get-all'));
//     if (response.statusCode == 200) {
//       Map<String, dynamic> jsonResponse = json.decode(response.body);
//       List<dynamic> jsonList = jsonResponse['data'];
//       demoProducts = jsonList.map((json) => Product.fromJson(json)).toList();

//       // Lưu dữ liệu và thời gian cập nhật vào cache
//       prefs.setString('products', json.encode(jsonList));
//       prefs.setInt('lastFetchTime', currentTime);
//     } else {
//       throw Exception('Failed to load products');
//     }
//     }
//   } catch (e) {
//     print('Error fetching products: $e');
//     // Handle error as per your app's requirements
//   }
// }
Future<void> fetchProducts(BuildContext context) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getString('products');
    final currentTime = DateTime.now().millisecondsSinceEpoch;
    final lastFetchTime = prefs.getInt('lastFetchTime') ?? 0;


    if (cachedData != null && currentTime - lastFetchTime < 200000) {
      demoProducts = (json.decode(cachedData) as List)
          .map((json) => Product.fromJson(json))
          .toList();
    } else {
      final response = await http.get(Uri.parse('http://localhost:3001/api/product/get-all'));
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        List<dynamic> jsonList = jsonResponse['data'];
        demoProducts = jsonList.map((json) => Product.fromJson(json)).toList();

        prefs.setString('products', json.encode(jsonList));
        prefs.setInt('lastFetchTime', currentTime);
      } else {
        throw Exception('Failed to load products');
      }
    }
  } catch (e) {
    print('Error fetching products: $e');
    // Handle error as per your app's requirements
  }
}

  

Uint8List _decodeBase64(String base64String) {
  return base64Decode(base64String);
}
