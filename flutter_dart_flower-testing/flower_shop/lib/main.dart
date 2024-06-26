import 'package:flutter/material.dart';
import 'package:health_care/screens/cart_screen/cart_provider.dart';
import 'package:health_care/screens/search_screen/components/search_provider.dart';
import 'package:health_care/theme.dart';
import 'package:provider/provider.dart';
import 'routes.dart';
import 'package:health_care/screens/splash_screen/splash_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) =>
                CartProvider()), // Thay thế bằng lớp Provider của bạn
        // Các provider khác nếu cần thiết
        ChangeNotifierProvider(create: (_) => SearchProvider()),
      ],
      child: MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: SplashScreen.routeName,
      routes: routes,
      theme: AppTheme.lightTheme(context),
    );
  }
}
