import 'package:flutter/material.dart';

class SplashContent extends StatelessWidget {
  final String? image;

  // ignore: use_super_parameters
  const SplashContent({
    Key? key,
    this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.cover,
      child: Image.asset(
        image!,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
      ),
    );
  }
}
