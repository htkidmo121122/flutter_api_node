import 'package:flutter/material.dart';



class SpecialOffers extends StatelessWidget {
  const SpecialOffers({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SizedBox(height: 15),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              SpecialOfferCard(
                image: "assets/images/banner1.png",
                // category: "Flower",
                // numOfBrands: 18,
                // press: () {
                  
                // },
              ),
              SpecialOfferCard(
                image: "assets/images/banner2.png",
                // category: "Gift",
                // numOfBrands: 24,
                // press: () {
                  
                // },
              ),
              SizedBox(width: 20),
            ],
          ),
        ),
      ],
    );
  }
}

class SpecialOfferCard extends StatelessWidget {
  const SpecialOfferCard({
    Key? key,
    // required this.category,
    required this.image,
    // required this.numOfBrands,
    // required this.press,
  }) : super(key: key);

  final String image;
  // final int numOfBrands;
  // final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: GestureDetector(
        // onTap: press,
        child: SizedBox(
          width: 300,
          height: 150,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              children: [
                Image.asset(
                  image,
                  width: 300,
                  height: 150,
                  fit: BoxFit.cover,
                ),
                // Container(
                //   decoration: const BoxDecoration(
                //     gradient: LinearGradient(
                //       begin: Alignment.topCenter,
                //       end: Alignment.bottomCenter,
                //       colors: [
                //         Colors.black54,
                //         Colors.black38,
                //         Colors.black26,
                //         Colors.transparent,
                //       ],
                //     ),
                //   ),
                // ),
                // Padding(
                //   padding: const EdgeInsets.symmetric(
                //     horizontal: 15,
                //     vertical: 10,
                //   ),
                //   child: Text.rich(
                //     TextSpan(
                //       style: const TextStyle(color: Colors.white),
                //       children: [
                //         TextSpan(
                //           text: "$category\n",
                //           style: const TextStyle(
                //             fontSize: 18,
                //             fontWeight: FontWeight.bold,
                //           ),
                //         ),
                //         TextSpan(text: "$numOfBrands sản phẩm")
                //       ],
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
