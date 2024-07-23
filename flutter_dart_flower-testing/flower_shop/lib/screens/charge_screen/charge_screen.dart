import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:health_care/provider/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  String _responseMessage = '';

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _changePassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userDataString = prefs.getString('user_data');
      String? token = prefs.getString('access_token');
      if (userDataString != null && token != null) {
        Map<String, dynamic> userData = jsonDecode(userDataString);
        final accessToken = token;
        final userId = userData['_id'];

        // Perform the change password action
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        try {
          final responseData = await authProvider.changePassword(
            oldPassword: _oldPasswordController.text,
            newPassword: _newPasswordController.text,
            userId: userId,
            token: accessToken,
          );
          setState(() {
            _responseMessage = responseData['message'];
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_responseMessage),
            ),
          );
          // ScaffoldMessenger.of(context).showSnackBar(
          //   const SnackBar(
          //     content: Text('Password changed successfully'),
          //   ),
          // );
        } catch (error) {
          setState(() {
            _responseMessage = '$error';
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_responseMessage),
            ),
          );
        } 
      } else {
        setState(() {
          _responseMessage = 'User data or token not found';
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_responseMessage),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Password'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 16),
              TextFormField(
                controller: _oldPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Old Password',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your old password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _newPasswordController,
                decoration: const InputDecoration(
                  labelText: 'New Password',
                  border: OutlineInputBorder(),
                  ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your new password';
                  }
                  if (value.length < 8) {
                    return 'Password must be at least 8 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16,),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: const InputDecoration(
                  labelText: 'Confirm New Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your new password';
                  }
                  if (value != _newPasswordController.text) {
                    return 'Password do not match';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: 150,
                  child: _isLoading
                      ? Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            padding:
                                const EdgeInsets.symmetric(vertical: 12),
                            textStyle: const TextStyle(
                                fontSize: 16, color: Colors.white),
                          ),
                          onPressed: _changePassword,
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
