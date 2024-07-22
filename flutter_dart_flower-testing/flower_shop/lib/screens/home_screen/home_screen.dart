import 'package:flutter/material.dart';
import 'package:health_care/constants.dart';
import 'package:health_care/models/Product.dart';

import 'package:health_care/screens/home_screen/components/animated_banner.dart';
import 'package:health_care/screens/home_screen/components/all_product.dart';
import 'package:health_care/screens/home_screen/components/search_field.dart';
import 'package:health_care/screens/home_screen/components/categories.dart';
import 'package:health_care/screens/home_screen/components/discount_banner.dart';
import 'package:health_care/screens/home_screen/components/home_header.dart';
import 'package:health_care/screens/home_screen/components/popular_product.dart';
import 'package:health_care/screens/home_screen/components/special_offers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = "/home";

  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
 Future<void> _refreshProducts(BuildContext context) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('products');
    // Gọi hàm fetchProducts và truyền context vào
    await fetchProducts(context);
    // Thông báo làm mới thành công
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Dữ liệu sản phẩm đã được làm mới!')),
    );
  } catch (e) {
    // Xử lý lỗi nếu có
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Lỗi khi làm mới dữ liệu: $e')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(context),
        child: const SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Column(
              children: [
                HomeHeader(),
                SizedBox(height: 20),
                // SearchField(),
                AnimatedBanner(),
                // SpecialOffers(),
                // DiscountBanner(),
                SizedBox(height: 10),
                Categories(),
                SizedBox(height: 10),
                PopularProducts(),
                SizedBox(height: 20),
                SizedBox(
                  height: 600, // Chiều cao cố định cho DiscountProducts
                  child: AllProducts(),
                ),
                SizedBox(height: 20),
                // DiscountProduct()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
