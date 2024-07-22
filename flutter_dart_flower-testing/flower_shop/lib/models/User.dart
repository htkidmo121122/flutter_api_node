import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class User {
  final String id; // ID người dùng
  final String? fullName; // name
  final String email; // email
  final String? phoneNumber; // phone
  final String? country; // city
  final String? address; // address
  final String? image; // avatar

  User({
    required this.id,
    this.fullName,
    required this.email,
    this.phoneNumber,
    this.country,
    this.address,
    this.image,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      fullName: json['name'],
      email: json['email'],
      phoneNumber: json['phone'],
      country: json['city'],
      address: json['address'],
      image: json['avatar'],
    );
  }
}

List<Map<String, dynamic>> demoUsers = [];
   

Future<void> fetchUsers(BuildContext context) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');
    print(token);
    if (token != null) {
      final accessToken = token;

      final url = Uri.parse('http://localhost:3001/api/user/getAll');
      final headers = {
        'Content-Type': 'application/json',
        'token': 'Bearer $accessToken',
      };
      print('Dang lay du lieu nguoiw dung');
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
            demoUsers = List<Map<String, dynamic>>.from(data['data']);
        } else {
          //Handle API response error
          print('Error: ${data['message']}');
        }
      } else {
        // Handle HTTP error
        print('HTTP Error: ${response.statusCode}');
      }
    }
  } catch (e) {
    print('Error fetching users: $e');
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
