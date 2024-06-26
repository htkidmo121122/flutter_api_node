import 'package:flutter/material.dart';
import 'package:health_care/screens/signin_screen/signin_screen.dart';
import '../constants.dart';

class HaveAccountText extends StatelessWidget {
  const HaveAccountText({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Already have an account? ",
          style: TextStyle(fontSize: 16),
        ),
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, SignInScreen.routeName),
          child: const Text(
            "Login",
            style: TextStyle(fontSize: 16, color: kSecondaryColor, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}