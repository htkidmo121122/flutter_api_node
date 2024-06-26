import 'package:flutter/material.dart';
import 'package:health_care/constants.dart';
import 'package:health_care/screens/signin_screen/signin_screen.dart';

class SuccessfulotpScreen extends StatelessWidget {
  const SuccessfulotpScreen({super.key});

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
                    'assets/images/SuccessfulOTP.png', // Ensure the path is correct
                    height: 350,
                    width: 350, // Adjust height as needed
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Successful",
                    style: TextStyle(fontSize: 30),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Your account password have been reset",
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 50),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context, SignInScreen.routeName);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 255, 255, 255),
                        padding: EdgeInsets.symmetric(vertical: 12),
                        minimumSize: Size(double.infinity,
                          50), // Set kích thước tối thiểu
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(color: kPrimaryColor, width: 1),
                        ),
                      ),
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: kPrimaryColor),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}