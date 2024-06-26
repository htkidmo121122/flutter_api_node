import 'package:flutter/material.dart';
//mau chinh, mau phu
const kcolormajor  = Color(0xFFFFBBCB);
const kcolorminor  = Color(0xFFFF85A1);

//random color background list
const color1 = Color(0xFF86CDEC);
const color2 = Color(0xFF967BB6);
const colot3 = Color(0xFFFFE454);
const color4 = Color(0xFFFFBBCB);
//mau co ban
const white = Colors.white;
const black = Colors.black;

//mau nut dam, mau nut nhat
const kPrimaryColor = Color.fromRGBO(0, 0, 0, 1);
const kWhite = Color.fromARGB(255, 182, 182, 182);
const kPrimaryLightColor = Color.fromARGB(255, 65, 65, 65);
const kPrimaryGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFFFFA53E), Color(0xFFFF7643)],
);
//mau navigator
const kSecondaryColor = Color(0xFFFA1056);
//mau text
const kTextColor = Colors.black;


const kAnimationDuration = Duration(milliseconds: 200);

const headingStyle = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.bold,
  color: Colors.black,
  height: 1.5,
);

const defaultDuration = Duration(milliseconds: 250);

// Form Error
final RegExp emailValidatorRegExp =
    RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
const String kEmailNullError = "Please Enter your email";
const String kInvalidEmailError = "Please Enter Valid Email";
const String kPassNullError = "Please Enter your password";
const String kShortPassError = "Password is too short";
const String kMatchPassError = "Passwords don't match";
const String kNamelNullError = "Please Enter your name";
const String kPhoneNumberNullError = "Please Enter your phone number";
const String kAddressNullError = "Please Enter your address";
final String kOTPNullError = "OTP không được bỏ trống";
final String kInvalidOTPError = "OTP phải có 6 chữ số";

final otpInputDecoration = InputDecoration(
  contentPadding: const EdgeInsets.symmetric(vertical: 16),
  border: outlineInputBorder(),
  focusedBorder: outlineInputBorder(),
  enabledBorder: outlineInputBorder(),
);

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(16),
    borderSide: const BorderSide(color: kTextColor),
  );
}
