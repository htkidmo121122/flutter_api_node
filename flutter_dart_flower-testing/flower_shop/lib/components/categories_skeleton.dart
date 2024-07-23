import 'package:flutter/material.dart';
import 'package:skeleton_text/skeleton_text.dart';

class CategoryCardSkeleton extends StatelessWidget {
   const CategoryCardSkeleton({Key? key}) : super(key: key);

   @override
   Widget build(BuildContext context) {
     return Column(
       children: [
         SkeletonAnimation(
           shimmerColor: Colors.grey[300]!,
           borderRadius: BorderRadius.circular(10.0),
           shimmerDuration: 2000,
           child: Container(
             padding: const EdgeInsets.all(14),
             height: 56,
             width: 56,
             decoration: BoxDecoration(
               color: Colors.grey[300],
               borderRadius: BorderRadius.circular(10),
             ),
           ),
         ),
         const SizedBox(height: 4),
         SkeletonAnimation(
           shimmerColor: Colors.grey[300]!,
           borderRadius: BorderRadius.circular(10.0),
           shimmerDuration: 2000,
           child: Container(
             width: 60,
             height: 16,
             decoration: BoxDecoration(
               color: Colors.grey[300],
               borderRadius: BorderRadius.circular(10),
             ),
           ),
         ),
       ],
     );
   }
 }