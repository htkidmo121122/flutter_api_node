// services/favorite_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class FavoriteService {
  final String apiUrl = 'http://localhost:3001/api/favourite';

  Future<void> addFavorite(String userId, String productId) async {
    final response = await http.post(
      Uri.parse('$apiUrl/$userId'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'productId': productId,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add favorite');
    }
  }

  Future<void> removeFavorite(String userId, String productId) async {
    final response = await http.delete(
      Uri.parse('$apiUrl/$userId'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'productId': productId,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to remove favorite');
    }
  }

  Future<bool> isProductFavorite(String userId, String productId) async {
    final response = await http.get(
      Uri.parse('$apiUrl/$userId/check-favorite?productId=$productId'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['isFavorite'] as bool;
    } else {
      throw Exception('Failed to check if product is favorite');
    }
  }
}
