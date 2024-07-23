import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthProvider with ChangeNotifier {
  Future<Map<String, dynamic>> changePassword({required String oldPassword, required String newPassword, required String userId, required String token}) async {
    final url = Uri.parse('http://localhost:3001/api/user/change-password/$userId');
    try {
      final response = await http.put(
        url,
        headers: <String, String>{
          'token': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'oldPassword': oldPassword,
          'newPassword': newPassword,
        }),
      );

      final responseData = json.decode(response.body);
      if (responseData['status'] == 'OK') {
        notifyListeners();
        return responseData;
      } else {
        throw Exception(responseData['message']);
      }
    } catch (error) {
      throw error;
    }
  }
}
