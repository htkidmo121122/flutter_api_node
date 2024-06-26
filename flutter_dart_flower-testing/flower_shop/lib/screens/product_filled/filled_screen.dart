import 'package:flutter/material.dart';
import 'package:health_care/models/Product.dart';
import 'package:health_care/screens/home_screen/components/home_header.dart';
import 'package:health_care/screens/home_screen/components/search_field.dart';
import 'package:health_care/screens/product_filled/product_filled.dart';

class FilledScreen extends StatelessWidget {
  final String category;
  final List<Product> products;

  const FilledScreen({Key? key, required this.category, required this.products}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              const HomeHeader(),
              const SizedBox(height: 20),
              const SearchField(),
              const SizedBox(height: 20),
              Expanded(
                child: FilteredProductsPage(
                  category: category,
                  products: products,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
