import 'package:flutter/material.dart';
import 'package:health_care/components/have_account_text.dart';
import 'package:health_care/constants.dart';
import 'package:health_care/screens/forgotpass_screen/components/fogot_form.dart';
class ForgotPasswordScreen extends StatefulWidget {
  static String routeName = "/forgotpass";

  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Forgot Password",
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
                  const SizedBox(height: 10),
                  Image.asset(
                    'assets/images/splash_screen.png', // Ensure the path is correct
                    height: 350,
                    width: 350, // Adjust height as needed
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Forgot your password?  ",
                    style: TextStyle(fontSize: 30),
                  ),
                  const SizedBox(height: 30),
                  const FogotForm(),
                  const SizedBox(height: 20),
                  const HaveAccountText(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}