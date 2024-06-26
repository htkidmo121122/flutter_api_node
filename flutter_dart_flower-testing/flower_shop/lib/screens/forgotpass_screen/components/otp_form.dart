import 'package:flutter/material.dart';
import 'package:health_care/screens/forgotpass_screen/Reset_password_screen.dart';
import '../../../constants.dart';

class OTPForm extends StatefulWidget {
  const OTPForm({super.key});

  @override
  State<OTPForm> createState() => _OTPFormState();
}

class _OTPFormState extends State<OTPForm> {
  final _formKey = GlobalKey<FormState>();
  late String otp;

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
            keyboardType: TextInputType.number,
            onSaved: (newValue) => otp = newValue!,
            onChanged: (value) {
              if (value.isNotEmpty) {
                removeError(error: kOTPNullError);
              } else if (value.length == 6) {
                removeError(error: kInvalidOTPError);
              }
              return;
            },
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: kOTPNullError);
                return "Không được bỏ trống";
              } else if (value.length != 6) {
                addError(error: kInvalidOTPError);
                return "OTP phải có 6 chữ số";
              }
              return null;
            },
            decoration: InputDecoration(
              labelText: 'OTP',
              hintText: 'Enter OTP sent',
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
                  MaterialPageRoute(builder: (context) => ResetPassOTPScreen()),
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