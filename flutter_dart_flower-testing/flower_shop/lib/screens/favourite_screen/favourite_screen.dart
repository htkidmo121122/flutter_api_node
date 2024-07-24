import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:health_care/models/Product.dart';
import 'package:health_care/screens/details_screen/details_screen.dart';
import 'package:health_care/screens/favourite_screen/favourite_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class FavoritesScreen extends StatefulWidget {
  static String routeName = "/favorites";

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  bool _isLoading = true;
  List<Product> _favoriteProducts = [];

  @override
  void initState() {
    super.initState();
    _fetchFavoriteProducts();
  }

  Future<void> _fetchFavoriteProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userDataString = prefs.getString('user_data');
    String? accessToken = prefs.getString('access_token');

    if (userDataString == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Thông tin người dùng không có')),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      Map<String, dynamic> userData = jsonDecode(userDataString);
      final userId = userData['_id'];

      final url = Uri.parse('http://localhost:3001/api/favourite/$userId');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'token': 'Bearer $accessToken'
        },
      );
      if (response.statusCode == 200) {

        List<dynamic> jsonResponse = jsonDecode(response.body);
        setState(() {
          _favoriteProducts = jsonResponse
              .map((json) => Product.fromJson(json['product']))
              .toList();
          _isLoading = false;
        });
        
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi Khi Lấy Danh Sách Yêu Thích')),
        );
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sản Phẩm Yêu Thích'),
      ),
      body: _isLoading
          ? Center(child: Image.asset('assets/images/heart.gif'))
          : _favoriteProducts.isEmpty
              ? Center(child: Text('Không có sản phẩm yêu thích'))
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: GridView.builder(
                    itemCount: _favoriteProducts.length,
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      childAspectRatio: 0.7,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 16,
                    ),
                    itemBuilder: (context, index) => FavoriteCard(
                      favorite: _favoriteProducts[index],
                      onPress: () => {
                         Navigator.pushNamed(
                           context,
                           DetailsScreen.routeName,
                           arguments: ProductDetailsArguments(product: _favoriteProducts[index]  ),
                        ),
                      },
                    ),
                  ),
                ),
    );
  }
}
