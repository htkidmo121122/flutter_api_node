import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:health_care/screens/info_screen/info_screen.dart';
import 'package:health_care/screens/signin_screen/signin_screen.dart';
import 'dart:io';
import 'package:health_care/models/User.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});
  static String routeName = "/edit_info";

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  String _filePath = ''; // Đường dẫn của hình ảnh đã chọn
  String _imageBase64 = ''; // Dữ liệu của hình ảnh được chọn dạng base64

  late User user;
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final countryController = TextEditingController();
  final addressController = TextEditingController();
  Uint8List? userImage;
  bool isLoading = true;
  bool isSaving = false;

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
          id: userData['_id'],
          fullName: userData['name']?.toString() ?? '',
          email: userData['email'],
          phoneNumber: userData['phone']?.toString() ?? '',
          country: userData['city']?.toString() ?? '',
          address: userData['address']?.toString() ?? '',
          image: userData['avatar'],
        );

        if (user.image != null) {
          String base64String = user.image!;
          // Tách phần base64 ra khỏi header
          String base64Image = base64String.split(',').last;
          // Giải mã chuỗi base64 thành mảng byte
          userImage = Uint8List.fromList(base64.decode(base64Image));
        }

        // Cập nhật giá trị của các TextEditingController
        fullNameController.text = user.fullName!;
        emailController.text = user.email;
        phoneNumberController.text = '0' + user.phoneNumber!;
        countryController.text = user.country!;
        addressController.text = user.address!;

        isLoading = false; // Đã tải xong dữ liệu
      });
    } else {
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

  Future<void> _saveUserData() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isSaving = true;
      });
      String? updatedImageBase64 = _imageBase64.isNotEmpty
          ? 'data:image/jpeg;base64,$_imageBase64'
          : user.image;

      user = User(
        id: '', //bỏ trống vì ko chỉnh sửa id người dùng
        fullName: fullNameController.text,
        email: emailController.text,
        phoneNumber: phoneNumberController.text,
        country: countryController.text,
        address: addressController.text,
        image: updatedImageBase64,
      );

      // Tạo dữ liệu JSON để gửi lên API
      Map<String, dynamic> updatedUserData = {
        'name': user.fullName,
        'email': user.email,
        'phone': user.phoneNumber,
        'city': user.country,
        'address': user.address,
        'avatar': user.image,
      };

      //Láy user id và token từ sharedpreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userDataString = prefs.getString('user_data');
      String? token = prefs.getString('access_token');
      if (userDataString != null || token != null) {
        Map<String, dynamic> userData = jsonDecode(userDataString!);
        final accessToken = token;
        final userId = userData['_id'];

        // Gửi yêu cầu PUT lên API
        String apiUrl =
            'http://localhost:3001/api/user/update-user/${userId}'; // Thay bằng URL API thực tế của bạn
        try {
          //////////Gọi Api
          var response = await http.put(
            Uri.parse(apiUrl),
            headers: <String, String>{
            'token': 'Bearer $accessToken',
            'Content-Type': 'application/json',
            },  
            body: jsonEncode(updatedUserData),
          );
          /////////Kiểm tra nếu token hết hạn
          if (response.statusCode == 404) {
            // Token hết hạn, refresh token và thử lại
            String? newToken = await refreshToken(); // lấy token mới
            if (newToken != null) {
              /////Gọi api lại với token mới
              response = await http.put(
                Uri.parse(apiUrl),
                headers: <String, String>{
                  'token': 'Bearer $newToken',
                  'Content-Type': 'application/json',
                },
                body: jsonEncode(updatedUserData),
              );
            }
          }
          //Gửi api thành công với token mới
          if (response.statusCode == 200) {
            try {
              final userData = jsonDecode(response.body);
              final userDetail = userData['data'];
              //load lại dữ liệu người dùng sau khi đã cập nhập vào sharedPreferences

              final SharedPreferences prefs =
                  await SharedPreferences.getInstance();

              await prefs.setString(
                  'user_data', jsonEncode(userDetail)); //luu duoi dang json

              Navigator.pushNamed(context, PersonalInfoScreen.routeName);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Sửa thông tin thành công')),
              );
            } catch (e) {
              // Handle JSON parse error
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed To Parse')),
              );
            }
          } 
          else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Lỗi khi cập nhật thông tin người dùng')),
            );
          }
        } catch (e) {
          print('Lỗi khi gửi yêu cầu PUT: $e');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Lỗi khi gửi yêu cầu cập nhật')),
          );
        } finally {
          setState(() {
            isSaving = false;
          });
        }
      }
    }
  }

//hàm lấy token mới khi token cũ hết han
  Future<String?> refreshToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? refreshToken = prefs.getString('refresh_token');
    if (refreshToken == null) {
      // Không có refresh token
      return null;
    }

    final response = await http.post(
      Uri.parse(
          'http://localhost:3001/api/user/refresh-token'), // Thay URL bằng URL API thực tế của bạn
      headers: <String, String>{
        'token': 'Bearer $refreshToken',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = jsonDecode(response.body);
      String newAccessToken = responseData['access_token'];
      await prefs.setString('access_token', newAccessToken);
      return newAccessToken;
    } else {
      // Xử lý lỗi
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider backgroundImage;
    try {
      if (_imageBase64.isNotEmpty) {
        backgroundImage = MemoryImage(base64Decode(_imageBase64));
      } else if (userImage != null) {
        backgroundImage = MemoryImage(userImage!);
      } else {
        backgroundImage = AssetImage('assets/images/profile_image.png');
      }
    } catch (e) {
      print("Lỗi khi tải hình ảnh: $e");
      backgroundImage = AssetImage('assets/images/profile_image.png');
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Sửa Thông Tin Người Dùng"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: backgroundImage,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: _pickImage,
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
                                Icons.camera_alt,
                                color: Colors.black,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                        ]
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: fullNameController,
                      decoration: const InputDecoration(
                        labelText: 'Tên',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Điền Tên';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: emailController,
                      enabled: false,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Điền Email';
                        }
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'Điền Email Hợp Lệ';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: phoneNumberController,
                      decoration: const InputDecoration(
                        labelText: 'Số Điện Thoại',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Điền Số Điện Thoại';
                        }
                        if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                          return 'Điền Số Điện Thoại Khả Dụng';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: countryController,
                      decoration: const InputDecoration(
                        labelText: 'Thành Phố',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Điền Thành Phố Của Bạn';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: addressController,
                      decoration: const InputDecoration(
                        labelText: 'Địa Chỉ',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Điền Địa Chỉ';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),
                    Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: 150,
                        child: isSaving
                            ? Center(child: CircularProgressIndicator())
                            : ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  textStyle: const TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                                onPressed: _saveUserData,
                                child: const Text('Lưu',
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
