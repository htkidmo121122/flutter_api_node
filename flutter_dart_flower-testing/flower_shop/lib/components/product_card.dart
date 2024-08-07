import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';

import 'package:intl/intl.dart'; // Import thư viện intl

import '../constants.dart';
import '../models/Product.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    Key? key,
    this.width = 140,
    this.aspectRetio = 1.02,
    required this.product,
    required this.onPress,
  }) : super(key: key);

  final double width, aspectRetio;
  final Product product;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    // Define a list of colors
    final List<Color> colors = [
      color1, color2, color3, color4
    ];

    // Select a random color from the list
    final Color randomColor = colors[Random().nextInt(colors.length)];

    // Định dạng số tiền
    final formattedPrice = NumberFormat.currency(locale: 'vi_VN', symbol: '₫').format(product.price);

    return SizedBox(
      width: width,
      child: GestureDetector(
        onTap: onPress,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1.02,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: randomColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Image.memory(base64Decode(product.images)),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              product.title,
              style: Theme.of(context).textTheme.bodyMedium,
              maxLines: 2,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  formattedPrice,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: kPrimaryColor,
                  ),
                ),
                // Nếu cần sử dụng lại phần yêu thích, bỏ ghi chú các dòng dưới
                // InkWell(
                //   borderRadius: BorderRadius.circular(50),
                //   onTap: () {},
                //   child: Container(
                //     padding: const EdgeInsets.all(6),
                //     height: 24,
                //     width: 24,
                //     decoration: BoxDecoration(
                //       color: product.isFavourite
                //           ? kPrimaryColor.withOpacity(0.15)
                //           : kSecondaryColor.withOpacity(0.1),
                //       shape: BoxShape.circle,
                //     ),
                //     child: SvgPicture.asset(
                //       "assets/icons/heart.svg",
                //       colorFilter: ColorFilter.mode(
                //           product.isFavourite
                //               ? const Color(0xFFFF4848)
                //               : const Color(0xFFDBDEE4),
                //           BlendMode.srcIn),
                //     ),
                //   ),
                // ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
