import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:health_care/constants.dart';
import 'package:health_care/models/CartItem.dart';
import 'package:health_care/screens/cart_screen/cart_provider.dart';

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
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: EdgeInsets.zero,
              elevation: 0,
              backgroundColor: Colors.white,
            ),
            child: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
              size: 20,
            ),
          ),
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
          ProductImages(product: product),
          TopRoundedContainer(
            color: Colors.white,
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
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: TopRoundedContainer(
        color: Colors.white,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: 
            ElevatedButton(
              onPressed: () {
                CartProvider cartProvider = Provider.of<CartProvider>(context, listen: false);
                cartProvider.addToCart(CartItem(
                  id: product.id,
                  name: product.title,
                  price: product.price,
                  img: product.images[0],
                  quantity: 1,
                ));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Added to Cart')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: black
              ),
              child: const Text(
                'Add To Cart',
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
