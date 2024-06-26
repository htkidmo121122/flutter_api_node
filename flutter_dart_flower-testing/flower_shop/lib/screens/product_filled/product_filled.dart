import 'package:flutter/material.dart';
import 'package:health_care/components/product_card.dart';
import 'package:health_care/models/Product.dart';
import 'package:health_care/screens/details_screen/details_screen.dart';
import 'package:health_care/screens/home_screen/components/home_header.dart';
import 'package:health_care/screens/home_screen/components/search_field.dart';

class FilteredProductsPage extends StatelessWidget {
  final String category;
  final List<Product> products;

  const FilteredProductsPage({Key? key, required this.category, required this.products}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Product> filteredProducts = products.where((product) => product.category == category).toList();

    return Scaffold(
      body: SafeArea(
        child: 
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$category',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20), // Add some space between the text and the grid
              Expanded(
                child: GridView.builder(
                  itemCount: filteredProducts.length,
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    childAspectRatio: 0.7,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 16,
                  ),
                  itemBuilder: (context, index) => ProductCard(
                    product: filteredProducts[index],
                    onPress: () => 
                      Navigator.pushNamed(
                      context,
                      DetailsScreen.routeName,
                      arguments:
                          ProductDetailsArguments(product: filteredProducts[index]),
                    ),  
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}