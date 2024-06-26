import 'package:flutter/material.dart';
import 'package:health_care/constants.dart';
import 'package:health_care/screens/home_screen/components/search_field.dart';

import 'components/categories.dart';
import './components/discount_banner.dart';
import 'components/home_header.dart';
import 'components/popular_product.dart';
import 'components/special_offers.dart';

class HomeScreen extends StatelessWidget {
  static String routeName = "/home";

  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              HomeHeader(),
              SizedBox(height: 20),
              // SearchField(),
              SpecialOffers(),
              // DiscountBanner(),
              Categories(),
              

              PopularProducts(),
              SizedBox(height: 20),
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
    );
  }
}
