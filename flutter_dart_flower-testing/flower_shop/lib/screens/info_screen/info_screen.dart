import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:health_care/constants.dart';
import 'package:health_care/screens/signin_screen/components/sign_form.dart';
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
  final addressController = TextEditingController();

  bool isLoading = true;
  Uint8List? userImage;

  bool isAdmin = false;

  @override
  void initState() {
    super.initState();
    loadUserData();
    checkrole();
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Xóa toàn bộ dữ liệu trong SharedPreferences
    Navigator.pushNamed(context, SignInScreen.routeName);
    // Điều hướng về màn hình đăng nhập
  }

  Future<void> checkrole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userDataString = prefs.getString('user_data');
    if (userDataString != null) {
      Map<String, dynamic> userData = jsonDecode(userDataString);
      setState(() {
        isAdmin = userData['isAdmin'] ?? false;
      });
    }
  }

  Future<void> loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userDataString = prefs.getString('user_data');
    
    if (userDataString != null) {
      Map<String, dynamic> userData = jsonDecode(userDataString);

      setState(() {
        user = User(
          fullName: userData['name']?.toString() ?? '',
          email: userData['email'],
          phoneNumber: userData['phone']?.toString() ?? '',
          country: userData['city']?.toString() ?? '',
          address: userData['address']?.toString() ?? '',
          image: userData['avatar'],
          
        );

       

        // Cập nhật giá trị của các TextEditingController
        // genderController.text = user.gender!;
        // fullNameController.text = user.fullName!;
        // emailController.text = user.email;
        // phoneNumberController.text = user.phoneNumber!;
        // countryController.text = user.country!;
        
        // addressController.text = user.address!;

        if(user.image != null)
        {
          String base64String = user.image!;
          // Tách phần base64 ra khỏi header
          String base64Image = base64String.split(',').last;
          // Giải mã chuỗi base64 thành mảng byte
          userImage = Uint8List.fromList(base64.decode(base64Image));
        }
        
        isLoading = false; // Đã tải xong dữ liệu
      });
    } else {
      // print('No user data found in SharedPreferences');
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
        title: const Text("Personal Information"),
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
            : 
           
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 16),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: userImage != null
                            ? MemoryImage(userImage!)
                            : const AssetImage('assets/images/profile_image.png') as ImageProvider,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed(EditProfileScreen.routeName);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(8),
                            child: const Icon(
                              Icons.edit,
                              color: Colors.black,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ]
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user.fullName!,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  // TextFormField(
                  //   controller: fullNameController,
                  //   decoration: const InputDecoration(
                  //     labelText: 'Full Name',
                  //     border: OutlineInputBorder(),
                  //   ),
                  // ),
                  // const SizedBox(height: 16),
                  // TextFormField(
                  //   controller: emailController,
                  //   decoration: const InputDecoration(
                  //     labelText: 'Email',
                  //     border: OutlineInputBorder(),
                  //   ),
                  // ),
                  // const SizedBox(height: 16),
                  // TextFormField(
                  //   controller: phoneNumberController,
                  //   decoration: const InputDecoration(
                  //     labelText: 'Phone Number',
                  //     border: OutlineInputBorder(),
                  //   ),
                  // ),
                  // const SizedBox(height: 16),
                  
                  // TextFormField(
                  //         controller: countryController,
                  //         decoration: const InputDecoration(
                  //           labelText: 'Country',
                  //           border: OutlineInputBorder(),
                  //         ),
                  //       ),
                 
                  //     const SizedBox(width: 16),
                  //     // Expanded(
                  //     //   child: TextFormField(
                  //     //     controller: genderController,
                  //     //     decoration: const InputDecoration(
                  //     //       labelText: 'Gender',
                  //     //       border: OutlineInputBorder(),
                  //     //     ),
                  //     //   ),
                  //     // ),
                 
                  // const SizedBox(height: 16),
                  // TextFormField(
                  //   controller: addressController,
                  //   decoration: const InputDecoration(
                  //     labelText: 'Address',
                  //     border: OutlineInputBorder(),
                  //   ),
                  // ),
                  Text(
                    isAdmin ? "Administrator" : "Customer",
                    style: const TextStyle(
                        fontSize: 20.0,
                        fontFamily: 'Source Sans Pro',
                        color: kcolorminor,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.5),
                  ),
                  const SizedBox(
                    width: 150.0,
                    height: 20.0,
                    child: Divider(
                      color: kcolormajor,
                    ),
                  ),
                  Card(
                    margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                    child: ListTile(
                      leading: const Icon(
                        Icons.phone,
                        color: kPrimaryColor,
                      ),
                      title: Text(
                        '+84 0${user.phoneNumber}',
                        style: const TextStyle(
                            fontSize: 20.0,
                           
                            ),
                      ),
                    ),
                  ),
                  Card(
                    margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                    child: ListTile(
                      leading: const Icon(
                        Icons.email,
                        color: kPrimaryColor,
                      ),
                      title: Text(
                        user.email,
                        style: const TextStyle(
                            fontSize: 20.0,
                            ),
                      ),
                    ),
                  ),
                  Card(
                    margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                    child: ListTile(
                      leading: const Icon(
                        Icons.location_city,
                        color: kPrimaryColor,
                      ),
                      title: Text(
                        user.address!,
                        style: const TextStyle(
                            fontSize: 20.0,
                            ),
                      ),
                    ),
                  ),
                  Card(
                    margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                    child: ListTile(
                      leading: const Icon(
                        Icons.location_city_outlined,
                        color: kPrimaryColor,
                      ),
                      title: Text(
                        user.country!,
                        style: const TextStyle(
                            fontSize: 20.0,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      }
