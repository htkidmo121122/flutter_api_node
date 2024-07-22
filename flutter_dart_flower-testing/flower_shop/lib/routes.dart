import 'package:flutter/widgets.dart';
import 'package:health_care/admin/Orders/Orders.dart';
import 'package:health_care/admin/Products/Products.dart';
import 'package:health_care/admin/Users/Users.dart';
import 'package:health_care/admin/adminpage.dart';
import 'package:health_care/mainpage.dart';
import 'package:health_care/screens/cart_screen/cart_screen.dart';
import 'package:health_care/screens/checkout/checkout.dart';
import 'package:health_care/screens/details_screen/details_screen.dart';
import 'package:health_care/screens/forgotpass_screen/forgotpass_screen.dart';
import 'package:health_care/screens/home_screen/home_screen.dart';
import 'package:health_care/screens/info_screen/edit_profile.dart';
import 'package:health_care/screens/info_screen/info_screen.dart';
import 'package:health_care/screens/myorder_screen/myorder_screen.dart';
import 'package:health_care/screens/setting_screen/setting_screen.dart';
import 'package:health_care/screens/signin_screen/signin_screen.dart';
import 'package:health_care/screens/signup_screen/signup_screen.dart';
import 'package:health_care/screens/splash_screen/splash_screen.dart';

final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => const SplashScreen(),
  SignInScreen.routeName: (context) => const SignInScreen(),
  SignUpScreen.routeName: (context) => const SignUpScreen(),
  HomeScreen.routeName: (context) => const HomeScreen(),
  Mainpage.routeName: (context) => const Mainpage(),
  CartScreen.routeName: (context) => const CartScreen(),
  SettingScreen.routeName: (context) => const SettingScreen(),
  PersonalInfoScreen.routeName: (context) => const PersonalInfoScreen(),
  DetailsScreen.routeName: (context) => const DetailsScreen(),
  EditProfileScreen.routeName: (context) => const EditProfileScreen(),
  ForgotPasswordScreen.routeName: (context) => const ForgotPasswordScreen(),
  ForgotPasswordScreen.routeName: (context) => const ForgotPasswordScreen(),
  Checkout.screenroute: (context) => const Checkout(),
  ProductsScreen.routeName: (context) => ProductsScreen(),
  MyOrdersScreen.routeName: (context) => MyOrdersScreen(),
  AdminMainPage.routeName: (context) => AdminMainPage(),
  AdminUsers.routeName: (context) => AdminUsers(),
  AdminOrdersScreen.routeName: (context) => AdminOrdersScreen(),
};
