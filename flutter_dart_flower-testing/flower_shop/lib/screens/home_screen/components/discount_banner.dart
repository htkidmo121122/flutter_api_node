import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:health_care/constants.dart';

class DiscountBanner extends StatelessWidget {
  const DiscountBanner({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 50,
      ),
      decoration: BoxDecoration(
        color: kcolormajor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text.rich(
        TextSpan(
          style: TextStyle(color: Colors.black),
          children: [
            TextSpan(text: "A Summer Surpise\n"),
            TextSpan(
              text: "Cashback 20%",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: kSecondaryColor,
                
                
              ),
              
              
            ),
          ],
        ),
      ),
    );
  }
}
