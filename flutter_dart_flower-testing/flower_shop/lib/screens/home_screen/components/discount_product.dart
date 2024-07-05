import 'package:flutter/material.dart';
import 'package:health_care/components/product_card.dart';
import 'package:health_care/models/Product.dart';
import 'package:health_care/screens/details_screen/details_screen.dart';
import 'package:health_care/screens/search_screen/components/search_provider.dart';
import 'package:provider/provider.dart';

import 'section_title.dart';

class DiscountProducts extends StatelessWidget {
  const DiscountProducts({super.key});


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: fetchProducts(context), // Gọi fetchProducts để tải dữ liệu
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error loading products'));
        } else {
          final searchQuery = Provider.of<SearchProvider>(context).searchQuery;
          final searchResults = demoProducts.where((product) {
            final titleLower = product.title.toLowerCase();
            final searchLower = searchQuery.toLowerCase();
            return titleLower.contains(searchLower);
          }).toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SectionTitle(
                  title: "Discount",
                  press: () {},
                ),
              ),
              const SizedBox(height: 5),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GridView.builder(
                    itemCount: searchResults.length,
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      childAspectRatio: 0.7,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 16,
                    ),
                    itemBuilder: (context, index) => ProductCard(
                      product: searchResults[index],
                      onPress: () => Navigator.pushNamed(
                        context,
                        DetailsScreen.routeName,
                        arguments: ProductDetailsArguments(product: searchResults[index]),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
