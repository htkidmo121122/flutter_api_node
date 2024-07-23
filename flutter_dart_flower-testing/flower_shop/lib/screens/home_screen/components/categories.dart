import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:health_care/components/categories_skeleton.dart';
import 'package:health_care/models/Product.dart';
import 'package:health_care/screens/product_filled/filled_screen.dart';
import 'package:skeleton_text/skeleton_text.dart';


class Categories extends StatelessWidget {
  const Categories({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: fetchProducts(context), // Gọi fetchProducts để tải dữ liệu
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Bạn đang tìm kiếm?',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                      5, // Số lượng skeleton cards muốn hiển thị
                      (index) => const CategoryCardSkeleton(),
                    ),
                  ),
                ]
            ),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error loading products'));
        } else {
          // Extract unique categories from products
          // lấy ra danh sách loại sản phẩm từ sản phẩm
          List<String> categories = demoProducts
              .map((product) => product.category)
              .toSet()
              .toList();

          
          // Define a map for icons associated with categories
          Map<String, String> categoryIcons = {
            "Flower": "assets/icons/flower.svg",
            "Gift": "assets/icons/gift.svg",
            "Special": "assets/icons/special.svg",
            "Collection": "assets/icons/dailygift.svg",
            "Wedding": "assets/icons/classify.svg",
          };
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Bạn đang tìm kiếm?',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      
                    ),
                  ),
                  const SizedBox(height: 20), // Optional SizedBox for spacing
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: 
                    List.generate(
                      categories.length,
                      (index) => CategoryCard(
                        icon: categoryIcons[categories[index]] ?? "assets/icons/flower.svg",
                        text: categories[index],
                        press: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FilledScreen(
                                category: categories[index],
                                products: demoProducts,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ]
            ),
          );
        }
      }
    );
  }
}

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    Key? key,
    required this.icon,
    required this.text,
    required this.press,
  }) : super(key: key);

  final String icon, text;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Column(
        children: [
          Container(
            
            padding: const EdgeInsets.all(14),
            height: 56,
            width: 56,
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2), // Shadow color with opacity
                  spreadRadius: 2, // Spread radius
                  blurRadius: 5, // Blur radius
                  offset: Offset(0, 3), // Offset in x and y direction
                ),
              ],
              border: Border.all(
                color: Colors.white.withOpacity(0.5), // Màu viền với độ mờ
                width: 1.5, // Độ dày của viền
              ),
            
            ),
            child: SvgPicture.asset(icon),
          ),
          const SizedBox(height: 4),
          Text(text, textAlign: TextAlign.center)
        ],
      ),
    );
  }
}


////Card Categoríes Skeleton Loading
///
// class CategoryCardSkeleton extends StatelessWidget {
//   const CategoryCardSkeleton({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         SkeletonAnimation(
//           shimmerColor: Colors.grey[300]!,
//           borderRadius: BorderRadius.circular(10.0),
//           shimmerDuration: 2000,
//           child: Container(
//             padding: const EdgeInsets.all(14),
//             height: 56,
//             width: 56,
//             decoration: BoxDecoration(
//               color: Colors.grey[300],
//               borderRadius: BorderRadius.circular(10),
//             ),
//           ),
//         ),
//         const SizedBox(height: 4),
//         SkeletonAnimation(
//           shimmerColor: Colors.grey[300]!,
//           borderRadius: BorderRadius.circular(10.0),
//           shimmerDuration: 2000,
//           child: Container(
//             width: 60,
//             height: 16,
//             decoration: BoxDecoration(
//               color: Colors.grey[300],
//               borderRadius: BorderRadius.circular(10),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }