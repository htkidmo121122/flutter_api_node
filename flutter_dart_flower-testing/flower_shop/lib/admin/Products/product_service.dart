import 'dart:convert';
import 'package:health_care/models/Product.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProductService {
  final String baseUrl = 'http://localhost:3001/api/product';

  Future<List<Product>> fetchProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getString('products');
    final currentTime = DateTime.now().millisecondsSinceEpoch;
    final lastFetchTime = prefs.getInt('lastFetchTime') ?? 0;

    if (cachedData != null && currentTime - lastFetchTime < 200000) {
      List<dynamic> jsonList = json.decode(cachedData);
      return jsonList.map((json) => Product.fromJson(json)).toList();
    } else {
      final response = await http.get(Uri.parse('$baseUrl/get-all'));
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        List<dynamic> jsonList = jsonResponse['data'];
        List<Product> products =
            jsonList.map((json) => Product.fromJson(json)).toList();

        prefs.setString('products', json.encode(jsonList));
        prefs.setInt('lastFetchTime', currentTime);
        return products;
      } else {
        throw Exception('Failed to load products');
      }
    }
  }

  Future<void> deleteProduct(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/delete/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete product');
    }
  }

  Future<void> addProduct(Product product) async {
    final response = await http.post(
      Uri.parse('$baseUrl/create'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(product.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to add product');
    }
  }
}
