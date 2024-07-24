import 'package:flutter/material.dart';
import 'package:health_care/components/product_card.dart';
import 'package:health_care/components/product_card_skeleton.dart';
import 'package:health_care/models/Product.dart';
import 'package:health_care/screens/details_screen/details_screen.dart';
import 'package:health_care/provider/search_provider.dart';
import 'package:provider/provider.dart';
import 'package:skeleton_text/skeleton_text.dart';


import 'section_title.dart';

class PopularProducts extends StatelessWidget {
  const PopularProducts({super.key});

  

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: fetchProducts(context), // Gọi fetchProducts để tải dữ liệu
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          return Container();
          // Column(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [
          //     Padding(
          //       padding: const EdgeInsets.symmetric(horizontal: 20),
          //       child: SectionTitle(
          //         title: "Sản Phẩm Mới Nhất",
          //         press: () {},
          //       ),
          //     ),
          //     const SizedBox(height: 5),
          //     SingleChildScrollView(
          //       scrollDirection: Axis.horizontal,
          //       child: Row(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: List.generate(
          //           4, // Số lượng skeleton cards muốn hiển thị
          //           (index) => const ProductCardSkeleton(),
          //         ),
          //       ),
          //     ),
          //   ],
          // );
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
                  title: "Sản Phẩm Mới Nhất",
                  press: () {},
                  
                ),
              ),
              
              const SizedBox(height: 5),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (searchResults.isEmpty)
                      const Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Text(
                          "Không tìm thấy sản phẩm nào",
                          style: TextStyle(fontSize: 15, color: Colors.red),
                        ),
                      ),
                    
                    SizedBox(height: 20),
                    ...List.generate(
                      searchResults.length,
                      (index) {
                      
                          return Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: ProductCard(
                              product: searchResults[index],
                              onPress: () => Navigator.pushNamed(
                                context,
                                DetailsScreen.routeName,
                                arguments: ProductDetailsArguments(product: searchResults[index]),
                              ),
                            ),
                          );
                 
                        return SizedBox.shrink();
                      },
                    ),
                    SizedBox(width: 20),
                  ],
                ),
              ),
            ],
          );
        }
      },
    );
  }
}

////Popular Product skeleton loading
///
// class ProductCardSkeleton extends StatelessWidget {
//   const ProductCardSkeleton({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(left: 20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SkeletonAnimation(
//             shimmerColor: Colors.grey[300]!,
//             borderRadius: BorderRadius.circular(10.0),
//             shimmerDuration: 2000,
//             child: Container(
//               height: 140,
//               width: 140,
//               decoration: BoxDecoration(
//                 color: Colors.grey[300],
//                 borderRadius: BorderRadius.circular(10),
//               ),
//             ),
//           ),
//           const SizedBox(height: 10),
//           SkeletonAnimation(
//             shimmerColor: Colors.grey[300]!,
//             borderRadius: BorderRadius.circular(10.0),
//             shimmerDuration: 2000,
//             child: Container(
//               width: 100,
//               height: 20,
//               decoration: BoxDecoration(
//                 color: Colors.grey[300],
//                 borderRadius: BorderRadius.circular(10),
//               ),
//             ),
//           ),
//           const SizedBox(height: 5),
//           SkeletonAnimation(
//             shimmerColor: Colors.grey[300]!,
//             borderRadius: BorderRadius.circular(10.0),
//             shimmerDuration: 2000,
//             child: Container(
//               width: 50,
//               height: 20,
//               decoration: BoxDecoration(
//                 color: Colors.grey[300],
//                 borderRadius: BorderRadius.circular(10),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }