import 'package:flutter/material.dart';
import 'package:skeleton_text/skeleton_text.dart';

class ProductCardSkeleton extends StatelessWidget {
  const ProductCardSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SkeletonAnimation(
            shimmerColor: Colors.grey[300]!,
            borderRadius: BorderRadius.circular(10.0),
            shimmerDuration: 2000,
            child: Container(
              height: 140,
              width: 140,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 10),
          SkeletonAnimation(
            shimmerColor: Colors.grey[300]!,
            borderRadius: BorderRadius.circular(10.0),
            shimmerDuration: 2000,
            child: Container(
              width: 100,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 5),
          SkeletonAnimation(
            shimmerColor: Colors.grey[300]!,
            borderRadius: BorderRadius.circular(10.0),
            shimmerDuration: 2000,
            child: Container(
              width: 50,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}