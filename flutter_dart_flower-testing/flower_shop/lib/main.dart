import 'package:flutter/material.dart';
import 'package:health_care/mainpage.dart';
import 'package:health_care/screens/cart_screen/cart_provider.dart';
import 'package:health_care/screens/search_screen/components/search_provider.dart';
import 'package:health_care/theme.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'routes.dart';
import 'package:health_care/screens/splash_screen/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Kiểm tra trạng thái đăng nhập ở đây từ SharedPreferences)
  bool isLoggedIn = await checkLoginStatus(); // Hàm này trả về true nếu đã đăng nhập, ngược lại trả về false
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) =>
                CartProvider()), // Thay thế bằng lớp Provider của bạn
        // Các provider khác nếu cần thiết
        ChangeNotifierProvider(create: (_) => SearchProvider()),
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: isLoggedIn ? Mainpage.routeName : SplashScreen.routeName,
      routes: routes,
      theme: AppTheme.lightTheme(context),
    );
  }
}

Future<bool> checkLoginStatus() async {
  // Đoạn này làm việc với SharedPreferences để kiểm tra trạng thái đăng nhập
  // Ví dụ: Kiểm tra xem có token đã lưu không
  // Đoạn mã dưới đây chỉ là ví dụ, bạn cần thay thế bằng cách kiểm tra thực tế của bạn
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('access_token');

  return token != null; // Trả về true nếu có token, ngược lại false
}
