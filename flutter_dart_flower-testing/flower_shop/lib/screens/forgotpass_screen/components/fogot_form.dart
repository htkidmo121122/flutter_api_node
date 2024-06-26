import 'package:flutter/material.dart';
import 'package:health_care/screens/forgotpass_screen/OTPVerification_screen.dart';
import 'package:health_care/screens/signin_screen/signin_screen.dart';
import '../../../constants.dart';

class FogotForm extends StatefulWidget {
  const FogotForm({super.key});

  @override
  State<FogotForm> createState() => _FogotFormState();
}

class _FogotFormState extends State<FogotForm> {
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
            ),
          ),
          const SizedBox(height: 20),
          // FormError(errors: errors),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OTPVerificationScreen()),
                );
                _formKey.currentState!.save();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimaryColor,
              padding: EdgeInsets.symmetric(vertical: 12),
              minimumSize:
                  Size(double.infinity, 50), // Set kích thước tối thiểu
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: kPrimaryColor, width: 1),
                // Set border radius here
              ),
            ),
            child: const Text(
              "Send verification code",
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