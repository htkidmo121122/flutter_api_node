import 'package:flutter/material.dart';
import 'package:health_care/components/all_product_skeleton.dart';
import 'package:health_care/components/product_card.dart';
import 'package:health_care/models/Product.dart';
import 'package:health_care/screens/details_screen/details_screen.dart';
import 'package:health_care/provider/search_provider.dart';
import 'package:provider/provider.dart';
import 'package:health_care/components/product_sort.dart'; // Import the ProductSorter
import 'package:skeleton_text/skeleton_text.dart';

import 'section_title.dart';

class AllProducts extends StatefulWidget {
  const AllProducts({super.key});

  @override
  _AllProductsState createState() => _AllProductsState();
}

class _AllProductsState extends State<AllProducts> {
  List<Product> _sortedProducts = [];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: fetchProducts(context), // Gọi fetchProducts để tải dữ liệu mỗi khi truy cập vào trang
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          // Hiển thị các skeleton cards khi dữ liệu đang tải
          return Container();
          // Column(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [
          //     Padding(
          //       padding: const EdgeInsets.symmetric(horizontal: 20),
          //       child: Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //         children: [
          //           SectionTitle(
          //             title: "Tất Cả Sản Phẩm",
          //             press: () {},
          //           ),
          //         ],
          //       ),
          //     ),
          //     const SizedBox(height: 5),
          //     Expanded(
          //       child: Padding(
          //         padding: const EdgeInsets.symmetric(horizontal: 20),
          //         child: GridView.builder(
          //           itemCount: 8, // Số lượng skeleton cards muốn hiển thị
          //           gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          //             maxCrossAxisExtent: 200,
          //             childAspectRatio: 0.7,
          //             mainAxisSpacing: 20,
          //             crossAxisSpacing: 16,
          //           ),
          //           itemBuilder: (context, index) => const AllCardSkeleton(),
          //         ),
          //       ),
          //     ),
          //   ],
          // );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error loading products'));
        } else {
          //lay ds san phẩm theo từ khoá tìm kiếm tu ds san pham tong (demoProduct)
          final searchQuery = Provider.of<SearchProvider>(context).searchQuery;
          List<Product> searchResults = demoProducts.where((product) {
            final titleLower = product.title.toLowerCase();
            final searchLower = searchQuery.toLowerCase();
            return titleLower.contains(searchLower);
          }).toList();
          //lay ds san pham vua loc theo gia vua theo tim kiem
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
                    SectionTitle(
                      title: "Tất Cả Sản Phẩm",
                      press: () {},
                    ),
                    ProductSorter(
                      products: searchResults,
                      onSorted: (sortedProducts) {
                        setState(() {
                          _sortedProducts = sortedProducts;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5),
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
                      onPress: () => Navigator.pushNamed(
                        context,
                        DetailsScreen.routeName,
                        arguments: ProductDetailsArguments(product: displayedProducts[index]),
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




