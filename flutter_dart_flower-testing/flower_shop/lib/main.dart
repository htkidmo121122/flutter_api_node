import 'package:flutter/material.dart';
import 'package:health_care/mainpage.dart';
import 'package:health_care/provider/auth_provider.dart';
import 'package:health_care/provider/cart_provider.dart';
import 'package:health_care/provider/search_provider.dart';
import 'package:health_care/provider/theme_provider.dart';
import 'package:health_care/theme.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'routes.dart';
import 'package:health_care/screens/splash_screen/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool isLoggedIn = await checkLoginStatus();
  bool isDarkMode = await checkDarkMode();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => SearchProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider(isDarkMode)),
      ],
      child: MainApp(isLoggedIn: isLoggedIn),
    ),
  );
}

class MainApp extends StatelessWidget {
  final bool isLoggedIn;

  const MainApp({Key? key, required this.isLoggedIn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: isLoggedIn ? Mainpage.routeName : SplashScreen.routeName,
          routes: routes,
          theme: themeProvider.isDarkMode
              ? AppTheme.darkTheme(context)
              : AppTheme.lightTheme(context),
        );
      },
    );
  }
}

Future<bool> checkLoginStatus() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('access_token');
  return token != null;
}

Future<bool> checkDarkMode() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool('isDarkMode') ?? false;
}
