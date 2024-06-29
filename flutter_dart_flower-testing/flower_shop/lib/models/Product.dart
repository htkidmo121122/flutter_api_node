import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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

  

  Product({
    required this.id,
    required this.images,
    required this.rating,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    this.discount,
    required this.countInStock,
    this.selled


    
  });

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
      selled: json['selled'] ?? 0
    );
  }
}

List<Product> demoProducts = [];

Future<void> fetchProducts(BuildContext context) async {
  try {
    //sau này thay đường dẫn này thành api api/product/getAll
    // Update the URL to your actual API endpoint
    final response = await http.get(Uri.parse('http://localhost:3001/api/product/get-all'));
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      List<dynamic> jsonList = jsonResponse['data']; 
      demoProducts = jsonList.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  } catch (e) {
    print('Error fetching products: $e');
    // Handle error as per your app's requirements
  }
}

Uint8List _decodeBase64(String base64String) {
  return base64Decode(base64String);
}
