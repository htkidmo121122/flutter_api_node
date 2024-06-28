import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:health_care/screens/info_screen/info_screen.dart';
import 'package:health_care/screens/signin_screen/signin_screen.dart';

import 'dart:io';

import 'package:health_care/models/User.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});
  static String routeName = "/edit_info";

  @override
  // ignore: library_private_types_in_public_api
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  String _filePath = ''; // Đường dẫn của hình ảnh đã chọn
  String _imageBase64 = ''; // Dữ liệu của hình ảnh dạng base64

  late User user;
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final countryController = TextEditingController();
  final addressController = TextEditingController();
  Uint8List? userImage;
  bool isLoading = true;

  // final List<String> genders = ['Nam', 'Nữ', 'Khác'];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    loadUserData();
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
          country: userData['city']?.toString() ?? 'N/A',
          address: userData['address']?.toString() ?? 'N/A',
          image: userData['avatar']?.toString() ?? '',

        );

        String base64String = user.image!;

        // Tách phần base64 ra khỏi header
        String base64Image = base64String.split(',').last;
        // Giải mã chuỗi base64 thành mảng byte
        userImage = Uint8List.fromList(base64.decode(base64Image));

        // Cập nhật giá trị của các TextEditingController
        fullNameController.text = user.fullName!;
        emailController.text = user.email;
        phoneNumberController.text = user.phoneNumber!;
        countryController.text = user.country!;
        // genderController.text = user.gender!;
        addressController.text = user.address!;

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

  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null) {
      PlatformFile file = result.files.first;
      setState(() {
        _filePath = file.path ?? '';
      });

      // Đọc và chuyển đổi hình ảnh sang base64
      if (_filePath.isNotEmpty) {
        File imageFile = File(_filePath);
        List<int> imageBytes = await imageFile.readAsBytes();
        setState(() {
          _imageBase64 = base64Encode(imageBytes);
        });
      }
    }
  }
  

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushNamed(PersonalInfoScreen.routeName);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage:  _imageBase64.isNotEmpty 
                      ? MemoryImage(
            base64Decode(_imageBase64), // Giả sử _imageBase64 là một chuỗi base64 đã được giải mã
          )
                      : MemoryImage(
                            userImage!)
                          as ImageProvider 
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: fullNameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your full name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: phoneNumberController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                    return 'Please enter a valid phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: countryController,
                decoration: const InputDecoration(
                  labelText: 'Country',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your country';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: addressController,
                decoration: const InputDecoration(
                  labelText: 'Address',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: 150, // Set the desired width for the button
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      textStyle:
                          const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Handle save functionality here
                        print('Save button pressed');
                        // You can add actual save logic here
                      }
                    },
                    child: const Text('Save',
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
