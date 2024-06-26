import 'package:flutter/material.dart';
import 'package:health_care/screens/forgotpass_screen/Successful_otp_screen.dart';
import 'package:health_care/screens/forgotpass_screen/forgotpass_screen.dart';
import '../../../constants.dart';

class ResetPassForm extends StatefulWidget {
  const ResetPassForm({super.key});

  @override
  State<ResetPassForm> createState() => _ResetPassFormState();
}

class _ResetPassFormState extends State<ResetPassForm> {
  final _formKey = GlobalKey<FormState>();
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
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SuccessfulotpScreen()),
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
                // Set border radius here
              ),
            ),
            child: const Text(
              "Confirm",
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