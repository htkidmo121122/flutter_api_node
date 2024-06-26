import 'package:flutter/material.dart';
import 'package:health_care/screens/home_screen/components/search_field.dart';
import 'package:health_care/screens/search_screen/components/search_provider.dart';
import 'package:provider/provider.dart';

import '../home_screen/components/categories.dart';

import '../home_screen/components/home_header.dart';
import '../home_screen/components/popular_product.dart';


class SearchScreen extends StatelessWidget {
  static String routeName = "/search";

  const SearchScreen({super.key});
  @override
  Widget build(BuildContext context) {
    //set changgenotifier cho trang screen search thoi
    return ChangeNotifierProvider(
      create: (_) => SearchProvider(),
      child: const Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Column(
              children: [
                HomeHeader(),
                SizedBox(height: 20),
                SearchField(),
                // SpecialOffers(),
                // DiscountBanner(),
                Categories(),
                PopularProducts(),
                SizedBox(height: 20),
                PopularProducts(),
                SizedBox(height: 20),
                PopularProducts(),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      )
    );
  }
}
