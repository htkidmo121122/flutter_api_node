import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:health_care/screens/signin_screen/signin_screen.dart';
import 'package:health_care/mainpage.dart';
import 'package:health_care/models/User.dart';
import 'package:health_care/screens/info_screen/edit_profile.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({Key? key}) : super(key: key);

  static String routeName = "/info";

  @override
  _PersonalInfoScreenState createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  late User user;

  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final countryController = TextEditingController();
  final genderController = TextEditingController();
  final addressController = TextEditingController();

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Xóa toàn bộ dữ liệu trong SharedPreferences
    Navigator.pushNamed(context, SignInScreen.routeName);
    // Điều hướng về màn hình đăng nhập
  }

  Future<void> loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userDataString = prefs.getString('user_data');
    if (userDataString != null) {
      Map<String, dynamic> userData = jsonDecode(userDataString);

      setState(() {
        user = User(
          fullName: userData['name']?.toString() ?? 'N/A',
          email: userData['email']?.toString() ?? 'N/A',
          phoneNumber: userData['phone']?.toString() ?? 'N/A',
          country: userData['address']?.toString() ?? 'N/A',
          gender: userData['gender']?.toString() ?? 'N/A',
          address: userData['address']?.toString() ?? 'N/A',
          password: '********',
          image: userData['avatar']?.toString() ?? 'assets/images/profile_image.png',
        );

        // Cập nhật giá trị của các TextEditingController
        fullNameController.text = user.fullName!;
        emailController.text = user.email!;
        phoneNumberController.text = user.phoneNumber!;
        countryController.text = user.country!;
        genderController.text = user.gender!;
        addressController.text = user.address!;

        isLoading = false; // Đã tải xong dữ liệu
      });
    } else {
      print('No user data found in SharedPreferences');
      // Xử lý khi không tìm thấy dữ liệu người dùng trong SharedPreferences
      isLoading = false; // Đã tải xong dữ liệu
      Navigator.pushNamed(context, SignInScreen.routeName);
      // Điều hướng về màn hình đăng nhập
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bạn chưa đăng nhập vào tài khoản')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Personal information"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushNamed(Mainpage.routeName);
          },
        ),
        actions: <Widget>[
          if (!isLoading)
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                logout();
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? Center(child: CircularProgressIndicator()) // Hiển thị loading khi đang tải dữ liệu
            : Column(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed(EditProfileScreen.routeName);
                    },
                    child: const CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage(
                        'assets/images/profile_image.png',
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user.fullName!,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: fullNameController,
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: phoneNumberController,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: TextFormField(
                          controller: countryController,
                          decoration: const InputDecoration(
                            labelText: 'Country',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: genderController,
                          decoration: const InputDecoration(
                            labelText: 'Gender',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: addressController,
                    decoration: const InputDecoration(
                      labelText: 'Address',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
