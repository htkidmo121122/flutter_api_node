import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:health_care/constants.dart';
import 'package:health_care/models/CartItem.dart';
import 'package:health_care/provider/cart_provider.dart';
import 'package:health_care/screens/details_screen/components/comment_section.dart';

import 'package:provider/provider.dart';


import '../../models/Product.dart';
import 'components/product_description.dart';
import 'components/product_images.dart';
import 'components/top_rounded_container.dart';

class DetailsScreen extends StatelessWidget {
  static String routeName = "/details";

  const DetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ProductDetailsArguments agrs =
        ModalRoute.of(context)!.settings.arguments as ProductDetailsArguments;
    final product = agrs.product;
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      // backgroundColor: white,
      appBar: AppBar(
        // elevation: 0,
        leading: 
        // Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: ElevatedButton(
        //     onPressed: () {
        //       Navigator.pop(context);
        //     },
        //     style: ElevatedButton.styleFrom(
        //         shape: const CircleBorder(),
        //        padding: EdgeInsets.zero,
        //        elevation: 0,
        //     ),
        //     child: const Icon(
        //       Icons.arrow_back_ios_new,
        //       size: 20,
        //     ),
        //   ),
        // ),
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          Row(
            children: [
              Container(
                margin: const EdgeInsets.only(right: 20),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    const Text(
                      "4.7",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    SvgPicture.asset("assets/icons/star.svg"),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: ListView(
        children: [
          const SizedBox(height: 20),
          ProductImages(product: product),
          TopRoundedContainer(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Column(
              children: [
                ProductDescription(
                  product: product,
                  // pressOnSeeMore: () {},
                ),
                // TopRoundedContainer(
                //   color: const Color(0xFFF6F7F9),
                //   child: Column(
                //     children: [
                //       // ColorDots(product: product),
                //     ],
                //   ),
                // ),
                const SizedBox(height: 10),
                CommentsSection(productId: product.id),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: TopRoundedContainer(
        color: Theme.of(context).scaffoldBackgroundColor.withOpacity(1),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: 
            ElevatedButton(
              onPressed: () {
                
                  CartProvider cartProvider = Provider.of<CartProvider>(context, listen: false);
                  bool result = cartProvider.addToCart(CartItem(
                    id: product.id,
                    name: product.title,
                    price: product.price,
                    img: product.images,
                    quantity: 1,
                    discount: product.discount,
                    stockCount: product.countInStock
                  ));
                  if(result){
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Đã thêm vào giỏ hàng'),
                      duration: Duration(milliseconds: 500)),
                    );
                  }
                  else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              backgroundColor: Colors.white, // Nền của AlertDialog
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  // Hiển thị file GIF ở phía trên
                                  Image.asset(
                                    'assets/images/outofstock.gif', // Thay đổi đường dẫn tới file GIF của bạn
                                    width: 100, // Điều chỉnh kích thước phù hợp
                                    height: 100, // Điều chỉnh kích thước phù hợp
                                  ),
                                  SizedBox(height: 16), // Khoảng cách giữa GIF và văn bản
                                  const Text('Sản phẩm đã hết hàng', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: black),),
                                ],
                              ),
                            );
                          },
                        );
                        Future.delayed(Duration(seconds: 3), () {
                            Navigator.of(context, rootNavigator: true).pop();
                        });
                  }
                
                  
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryColor
                ),
                child: const Text(
                  'Thêm vào giỏ hàng',
                style: TextStyle(
                  color: white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ProductDetailsArguments {
  final Product product;

  ProductDetailsArguments({required this.product});
}
