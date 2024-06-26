import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';

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
  bool? remember = false;
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
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                // if all are valid then go to success screen
                // KeyboardUtil.hideKeyboard(context);
                // Navigator.pushNamed(context, LoginSuccessScreen.routeName);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimaryColor,
              padding: EdgeInsets.symmetric(vertical: 12),
              minimumSize:
                  Size(double.infinity, 50), // Set kích thước tối thiểu
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                // Set border radius here
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
