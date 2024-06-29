import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../constants.dart';
import '../../../models/Product.dart';

class ProductDescription extends StatefulWidget {
  const ProductDescription({
    Key? key,
    required this.product,
  }) : super(key: key);

  final Product product;

  @override
  _ProductDescriptionState createState() => _ProductDescriptionState();
}

class _ProductDescriptionState extends State<ProductDescription> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    // Tính giá tiền đã áp dụng discount
    double discountedPrice = widget.product.price * (1 - (widget.product.discount ?? 0) / 100);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            widget.product.title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 64),
          child: Row(
            children: [
              Text(
                "\$${discountedPrice.toStringAsFixed(2)}",
                style: TextStyle(
                  backgroundColor: kSecondaryColor,
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (widget.product.discount != null)
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(
                    "\$${widget.product.price.toStringAsFixed(2)}",
                    style: TextStyle(
                      color: Colors.grey,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 64),
          child: Text(
            widget.product.description,
            maxLines: isExpanded ? null : 3,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: GestureDetector(
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            child: Row(
              children: [
                Text(
                  isExpanded ? "Show Less" : "See More Detail",
                  style: TextStyle(fontWeight: FontWeight.w600, color: kPrimaryColor),
                ),
                const SizedBox(width: 5),
                Icon(
                  isExpanded ? Icons.arrow_upward : Icons.arrow_forward_ios,
                  size: 12,
                  color: kPrimaryColor,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
