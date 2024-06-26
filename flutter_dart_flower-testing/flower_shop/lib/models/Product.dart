import 'dart:convert';
import 'package:flutter/material.dart';

class Product {
  final int id;
  final String title, description;
  final List<String> images;
  final double rating, price;
  final bool isFavourite, isPopular;
  final String category;

  Product({
    required this.id,
    required this.images,
    this.rating = 0.0,
    this.isFavourite = false,
    this.isPopular = false,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      images: List<String>.from(json['images']),
      title: json['title'],
      price: json['price'].toDouble(),
      description: json['description'],
      rating: json['rating'] ?? 0.0,
      isFavourite: json['isFavourite'] ?? false,
      isPopular: json['isPopular'] ?? false,
      category: json['category'],
    );
  }
}

List<Product> demoProducts = [];

Future<void> fetchProducts(BuildContext context) async {
  try {
    //sau này thay đường dẫn này thành api api/product/getAll
    String jsonData = await DefaultAssetBundle.of(context).loadString('assets/products.json');
    List<dynamic> jsonList = json.decode(jsonData);
    demoProducts = jsonList.map((json) => Product.fromJson(json)).toList();
  } catch (e) {
    print('Error fetching products: $e');
    // Handle error as per your app's requirements
  }
}
