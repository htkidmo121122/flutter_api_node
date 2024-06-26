import 'package:flutter/material.dart';
import 'package:health_care/constants.dart';
// import 'package:health_care/constants.dart';

import '../../components/no_account_text.dart';
// import '../../components/socal_card.dart';
import 'components/sign_form.dart';

class SignInScreen extends StatelessWidget {
  static String routeName = "/sign_in";

  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "ĐĂNG NHẬP",
          style: TextStyle(fontWeight: FontWeight.bold, color: kPrimaryColor),
        ),
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  // Optional welcome text
                  // Text(
                  //   "Welcome Back",
                  //   style: TextStyle(
                  //     color: Colors.black,
                  //     fontSize: 24,
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  // ),
                  // Text(
                  //   "Sign in with your email and password  \nor continue with social media",
                  //   textAlign: TextAlign.center,
                  // ),

                  // Add your image here
                  Image.asset(
                    'assets/images/splash_screen.png', // Ensure the path is correct
                    height: 350,
                    width: 350, // Adjust height as needed
                  ),
                  const SizedBox(height: 20),
                  const SignForm(),
                  const SizedBox(height: 20),
                  const NoAccountText(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
