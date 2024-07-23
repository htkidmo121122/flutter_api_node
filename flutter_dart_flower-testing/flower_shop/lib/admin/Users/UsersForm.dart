import 'package:flutter/material.dart';
import 'package:health_care/models/User.dart';
// Import model User

class UserForm extends StatefulWidget {
  final User? user;

  UserForm({this.user});

  @override
  _UserFormState createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final _formKey = GlobalKey<FormState>();
  late String fullName;
  late String email;
  late String phoneNumber;
  late String country;
  late String address;
  late String image;

  @override
  void initState() {
    super.initState();
    if (widget.user != null) {
      fullName = widget.user!.fullName ?? '';
      email = widget.user!.email;
      phoneNumber = widget.user!.phoneNumber ?? '';
      country = widget.user!.country ?? '';
      address = widget.user!.address ?? '';
      image = widget.user!.image ?? '';
    } else {
      fullName = '';
      email = '';
      phoneNumber = '';
      country = '';
      address = '';
      image = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user != null ? 'Edit User' : 'Add User'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: fullName,
                decoration: InputDecoration(labelText: 'Full Name'),
                onSaved: (value) => fullName = value!,
              ),
              TextFormField(
                initialValue: email,
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                onSaved: (value) => email = value!,
              ),
              TextFormField(
                initialValue: phoneNumber,
                decoration: InputDecoration(labelText: 'Phone Number'),
                onSaved: (value) => phoneNumber = value!,
              ),
              TextFormField(
                initialValue: country,
                decoration: InputDecoration(labelText: 'Country'),
                onSaved: (value) => country = value!,
              ),
              TextFormField(
                initialValue: address,
                decoration: InputDecoration(labelText: 'Address'),
                onSaved: (value) => address = value!,
              ),
              TextFormField(
                initialValue: image,
                decoration: InputDecoration(labelText: 'Image URL'),
                onSaved: (value) => image = value!,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    User newUser = User(
                      id: widget.user?.id ?? '',
                      fullName: fullName,
                      email: email,
                      phoneNumber: phoneNumber,
                      country: country,
                      address: address,
                      image: image,
                    );
                    if (widget.user != null) {
                      // Update user
                    } else {
                      // Add user
                    }
                    Navigator.pop(context, newUser);
                  }
                },
                child: Text(widget.user != null ? 'Update User' : 'Add User'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
