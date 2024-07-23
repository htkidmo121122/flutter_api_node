import 'package:flutter/material.dart';
import 'package:health_care/screens/signup_screen/signup_screen.dart';

import '../constants.dart';
// import '../screens/sign_up/sign_up_screen.dart';

class NoAccountText extends StatelessWidget {
  const NoAccountText({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Bạn Chưa Có Tài Khoản? ",
          style: TextStyle(fontSize: 16),
        ),
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, SignUpScreen.routeName),
          child: const Text(
            "Đăng Kí",
            style: TextStyle(fontSize: 16, color: kSecondaryColor, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
