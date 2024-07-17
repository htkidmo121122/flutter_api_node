import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:health_care/screens/signin_screen/signin_screen.dart';
// import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

// import '../../../components/custom_surfix_icon.dart';
// import '../../../components/form_error.dart';
import '../../../constants.dart';
// import '../../../helper/keyboard.dart';
// import '../../forgot_password/forgot_password_screen.dart';
// import '../../login_success/login_success_screen.dart';

class SignForm extends StatefulWidget {
  const SignForm({super.key});

  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {
  final _formKey = GlobalKey<FormState>();
  String? email;
  String? password;
  String? confirmPassword;
  bool? remember = false;
  bool _isLoading = false;

  final List<String?> errors = [];

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

  Future<void> _signup() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (email != null && password != null && confirmPassword != null) {
        setState(() {
          _isLoading = true;
        });

        try {
          final response = await http.post(
            Uri.parse('http://10.0.2.2:3001/api/user/sign-up'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, String>{
              'email': email!,
              'password': password!,
              'confirmPassword': confirmPassword!
            }),
          );

          if (response.statusCode == 200) {
            final data = jsonDecode(response.body);
            final message = data["message"];
            if (data["status"] == "ERR") {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('$message')),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Đăng Kí Thành Công')),
              );
              Navigator.pushNamed(context, SignInScreen.routeName);
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Sign Up failed: ${response.statusCode}')),
            );
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text('Failed to connect with server: ${e.toString()}')),
          );
        } finally {
          setState(() {
            _isLoading = false;
          });
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please fill out all fields')),
        );
      }
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
              hintText: 'Enter your email',
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
              fillColor: const Color.fromARGB(255, 255, 255, 255),

              // hintText: "Email",
              // // If  you are using latest version of flutter then lable text and hint text shown like this
              // // if you r using flutter less then 1.20.* then maybe this is not working properly
              // floatingLabelBehavior: FloatingLabelBehavior.always,
              // suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
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
              fillColor: const Color.fromARGB(255, 255, 255, 255),
              labelText: "Password",
              hintText: "Your Password",
              // If  you are using latest version of flutter then lable text and hint text shown like this
              // if you r using flutter less then 1.20.* then maybe this is not working properly
              // floatingLabelBehavior: FloatingLabelBehavior.always,
              // suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            obscureText: true,
            onSaved: (newValue) => confirmPassword = newValue,
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
              fillColor: const Color.fromARGB(255, 255, 255, 255),
              labelText: "Confirm Password",
              hintText: "Confirm Your Password",
              // If  you are using latest version of flutter then lable text and hint text shown like this
              // if you r using flutter less then 1.20.* then maybe this is not working properly
              // floatingLabelBehavior: FloatingLabelBehavior.always,
              // suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
            ),
          ),
          // Row(
          //   children: [
          //     // Checkbox(
          //     //   value: remember,
          //     //   activeColor: kPrimaryColor,
          //     //   onChanged: (value) {
          //     //     setState(() {
          //     //       remember = value;
          //     //     });
          //     //   },
          //     // ),
          //     // const Text("Remember me"),
          //     const Spacer(),
          //     GestureDetector(
          //       // onTap: () => Navigator.pushNamed(
          //       //     context, ForgotPasswordScreen.routeName),
          //       child: const Text(
          //         "Forgot Password?",
          //         style: TextStyle(),
          //       ),
          //     )
          //   ],
          // ),
          // FormError(errors: errors),
          const SizedBox(height: 16),
          _isLoading
              ? CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: _signup,
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
                    "Sign Up",
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
