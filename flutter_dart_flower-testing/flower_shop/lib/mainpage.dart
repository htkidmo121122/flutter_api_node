import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:health_care/constants.dart';
import 'package:health_care/screens/cart_screen/cart_screen.dart';
import 'package:health_care/screens/home_screen/home_screen.dart';
import 'package:health_care/screens/search_screen/search_screen.dart';
import 'package:health_care/screens/info_screen/info_screen.dart';
import 'package:health_care/screens/setting_screen/setting_screen.dart';
import 'package:health_care/screens/splash_screen/splash_screen.dart';

class Mainpage extends StatefulWidget {
  static String routeName = "/main";
  const Mainpage({super.key});

  @override
  State<Mainpage> createState() => _MainpageState();
}

class _MainpageState extends State<Mainpage> {
  int _selectedIndex = 2;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _loadWidget(int index) {
    // var nameWidgets = "None";
    switch (index) {
      case 0:
        return const CartScreen();

      case 1:
        return const SearchScreen();

      case 2:
        return const HomeScreen();

      case 3:
        return const SettingScreen();
      case 4:
        return const PersonalInfoScreen();
    }
    return const SplashScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Main content
      // appBar: AppBar(
      //   title: const Text(""),
      //   backgroundColor: Colors.white,
      // ),
      // drawer: Drawer(
      //   child: ListView(
      //     padding: EdgeInsets.zero,
      //     children: [
      //       DrawerHeader(
      //         decoration: const BoxDecoration(
      //           color: kSecondaryColor,
      //         ),
      //         child: Column(
      //           mainAxisAlignment: MainAxisAlignment.center,
      //           children: const [
      //             CircleAvatar(
      //               radius: 40,
      //               backgroundImage: NetworkImage(
      //                   'https://googleflutter.com/sample_image.jpg'),
      //             ),
      //             SizedBox(height: 8),
      //             Text('Your Name'),
      //             Text('yourmail@huﬂit.edu.vn'),
      //           ],
      //         ),
      //       ),
      //       ListTile(
      //         leading: const Icon(Icons.home),
      //         title: const Text('Home'),
      //         onTap: () {
      //           Navigator.pop(context);
      //           setState(() {
      //             _selectedIndex = 0;
      //           });
      //         },
      //       ),
      //       ListTile(
      //         leading: const Icon(Icons.contact_mail),
      //         title: const Text('Contact'),
      //         onTap: () {
      //           Navigator.pop(context);
      //           setState(() {
      //             _selectedIndex = 1;
      //           });
      //         },
      //       ),
      //       ListTile(
      //         leading: const Icon(Icons.supervised_user_circle),
      //         title: const Text('Info'),
      //         onTap: () {
      //           Navigator.pop(context);
      //           setState(() {
      //             _selectedIndex = 2;
      //           });
      //         },
      //       ),
      //       ListTile(
      //         leading: const Icon(Icons.person),
      //         title: const Text('Register'),
      //         onTap: () {
      //           Navigator.pop(context);
      //           setState(() {
      //             _selectedIndex = 3;
      //           });
      //         },
      //       ),
      //       const Divider(
      //         color: Colors.black,
      //       ),
      //       const ListTile(
      //         leading: Icon(Icons.exit_to_app),
      //         title: Text('Logout'),
      //       ),
      //     ],
      //   ),
      // ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: 'Cart',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Setting',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Personal',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: kSecondaryColor, // Change the selected item color as needed
          unselectedItemColor: Colors.grey,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed, // This prevents the labels from shifting when selected
        ),
      ),
      body: _loadWidget(_selectedIndex),
    );
  }
}
