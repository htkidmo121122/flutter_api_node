import 'package:flutter/material.dart';
import 'package:health_care/components/product_card.dart';
import 'package:health_care/models/Product.dart';
import 'package:health_care/screens/details_screen/details_screen.dart';
import 'package:health_care/screens/home_screen/components/home_header.dart';
import 'package:health_care/screens/home_screen/components/search_field.dart';
import 'package:health_care/components/product_sort.dart';
import 'package:health_care/provider/search_provider.dart';
import 'package:provider/provider.dart'; // Import the ProductSorter

class FilteredProductsPage extends StatefulWidget {
  final String category;
  final List<Product> products;

  const FilteredProductsPage({Key? key, required this.category, required this.products}) : super(key: key);

  @override
  _FilteredProductsPageState createState() => _FilteredProductsPageState();
}

class _FilteredProductsPageState extends State<FilteredProductsPage> {
  //Luu ds san pham loc theo gia 
  List<Product> _sortedProducts = [];

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
          //Lay ds san pham loc theo category
          List<Product> filteredProducts = widget.products.where((product) => product.category == widget.category).toList();
          //search san pham theo ds loc theo category loai
          final searchQuery = Provider.of<SearchProvider>(context).searchQuery;
          List<Product> searchResults = filteredProducts.where((product) {
            final titleLower = product.title.toLowerCase();
            final searchLower = searchQuery.toLowerCase();
            return titleLower.contains(searchLower);
          }).toList();
          //search san pham theo ds loc theo gia tien
          List<Product> searchSortResults = _sortedProducts.where((product) {
            final titleLower = product.title.toLowerCase();
            final searchLower = searchQuery.toLowerCase();
            return titleLower.contains(searchLower);
          }).toList();

          // Nếu không có tùy chọn sắp xếp, sử dụng ds san phẩm kết quả tìm kiếm
          List<Product> displayedProducts = _sortedProducts.isEmpty ? searchResults : searchSortResults;


          return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.category,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ProductSorter(
                          products: filteredProducts,
                          onSorted: (sortedProducts) {
                            setState(() {
                              _sortedProducts = sortedProducts;
                            });
                          },
                        ),
                      ],
                    ),
                    ),
                    const SizedBox(height: 20), // Add some space between the text and the grid
                    Expanded(
                      child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: GridView.builder(
                        itemCount: displayedProducts.length,
                        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 200,
                          childAspectRatio: 0.7,
                          mainAxisSpacing: 20,
                          crossAxisSpacing: 16,
                        ),
                        itemBuilder: (context, index) => ProductCard(
                          product: displayedProducts[index],
                          onPress: () =>
                              Navigator.pushNamed(
                            context,
                            DetailsScreen.routeName,
                            arguments:
                                ProductDetailsArguments(product: displayedProducts[index]),
                          ),
                        ),
                      ),
                    ),
                    )
                  ],
                );
        }
      },
    );
  }
}

