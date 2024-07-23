import 'package:flutter/material.dart';
import 'package:health_care/mainpage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../../constants.dart';
import '../../forgotpass_screen/forgotpass_screen.dart';

class SignForm extends StatefulWidget {
  const SignForm({super.key});

  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {
  final _formKey = GlobalKey<FormState>();
  String? email = '';
  String? password = '';
  bool? remember = false;
  final List<String?> errors = [];
  bool _isLoading = false;

  void addError({String? error}) {
    if (!errors.contains(error)) {
      setState(() {
        errors.add(error);
      });
    }
  }

  void removeError({String? error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });

      final response = await http.post(
        Uri.parse('http://localhost:3001/api/user/sign-in'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email!,
          'password': password!,
        }),
      );

      
      if (response.statusCode == 200) {
        try {
          final data = jsonDecode(response.body);
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('access_token',
              data['access_token']); //luu accesstoken duoi dang doi tuong dart
          await prefs.setString('refresh_token', data['refresh_token']);

          final decodedToken = JwtDecoder.decode(
              data['access_token']); //decode access token lay id nguoi dung
          final userId = decodedToken['id'];

          //Fetch user details using the access_token and userId
          await _getUserDetails(userId, data['access_token']);

          setState(() {
            _isLoading = false;
          });


          // Navigate to MyStoredDataPage after successful login
          Navigator.pushNamed(context, Mainpage.routeName);
          
          ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đăng nhập thành công')),
        );

          
        } catch (e) {
          final data = jsonDecode(response.body);
          final message = data['message'];
          // Handle JSON parse error
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${message}')),
          );
          setState(() {
            _isLoading = false;
          });
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: ${response.statusCode}')),
        );
      }
    }
  }

  Future<void> _getUserDetails(String userId, String token) async {
    final response = await http.get(
      Uri.parse('http://localhost:3001/api/user/get-details/$userId'),
      headers: <String, String>{
        'token': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      try {
        final userData = jsonDecode(response.body);
        final userDetail = userData['data'];
        
        // print(userDetail);
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        // user_data lưu trữ thông tin người dùng chi tiết
        await prefs.setString(
            'user_data', jsonEncode(userDetail)); //luu duoi dang json

        
      } catch (e) {
        // Handle JSON parse error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to parse user details')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Failed to fetch user details: ${response.statusCode}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            onSaved: (newValue) => email = newValue,
            onChanged: (value) {
              if (value.isNotEmpty) {
                removeError(error: kEmailNullError);
              } else if (emailValidatorRegExp.hasMatch(value)) {
                removeError(error: kInvalidEmailError);
              }
              return;
            },
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: kEmailNullError);
                return "Không được bỏ trống";
              } else if (!emailValidatorRegExp.hasMatch(value)) {
                addError(error: kInvalidEmailError);
                return "Email không tồn tại";
              }
              return null;
            },
            decoration: InputDecoration(
              labelText: 'Email',
              hintText: 'Email',
              floatingLabelBehavior: FloatingLabelBehavior.always,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey),
                gapPadding: 10,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: kPrimaryColor, width: 2),
                gapPadding: 10,
              ),
              filled: true,
              fillColor: Theme.of(context).scaffoldBackgroundColor
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            obscureText: true,
            onSaved: (newValue) => password = newValue,
            onChanged: (value) {
              if (value.isNotEmpty) {
                removeError(error: kPassNullError);
              } else if (value.length >= 8) {
                removeError(error: kShortPassError);
              }
              return;
            },
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: kPassNullError);
                return "Không được bỏ trống";
              } else if (value.length < 8) {
                addError(error: kShortPassError);
                return "Không được ít hơn 8 kí tự";
              }
              return null;
            },
            decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.always,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey),
                gapPadding: 10,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey),
                gapPadding: 10,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: kPrimaryColor, width: 2),
                gapPadding: 10,
              ),
              filled: true,
              fillColor: Theme.of(context).scaffoldBackgroundColor,
              labelText: "Mật Khẩu",
              hintText: "Mật Khẩu Của Bạn",
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const Spacer(),
              GestureDetector(
                onTap: () => Navigator.pushNamed(
                    context, ForgotPasswordScreen.routeName),
                child: const Text(
                  "Quên Mật Khẩu?",
                  style: TextStyle(
                      color: kSecondaryColor, fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
          const SizedBox(height: 16),
          _isLoading
              ? const CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: kPrimaryColor, width: 1),
                    ),
                  ),
                  child: const Text(
                    "Đăng Nhập",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
        ],
      ),
    );
  }
}
