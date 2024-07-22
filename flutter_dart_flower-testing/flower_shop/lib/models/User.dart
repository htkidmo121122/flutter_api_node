import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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

List<User> demoUsers = [];

Future<void> fetchUsers(BuildContext context) async {
  try {
    final response =
        await http.get(Uri.parse('http://10.0.2.2:3001/api/user/getAll'));
    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      demoUsers = jsonList.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  } catch (e) {
    print('Error fetching users: $e');
  }
}
