import 'package:flutter/material.dart';
import 'package:health_care/mainpage.dart';
import 'package:health_care/models/User.dart';
import 'package:health_care/screens/info_screen/edit_profile.dart';

class PersonalInfoScreen extends StatelessWidget {
  const PersonalInfoScreen({super.key});
  static String routeName = "/info";

  @override
  Widget build(BuildContext context) {
    // Dummy user data, you can replace this with actual data retrieval logic
    final user = User(
      fullName: 'Nguyen Van A',
      email: 'doanflutter@gmail.com',
      phoneNumber: '0989891234',
      country: 'Hồ Chí Minh',
      gender: 'Nam',
      address: '828 Sư Vạn Hạnh, Phường 13, Quận 10, TP.HCM',
      password: '********',
      image: 'assets/images/profile_image.png',
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Personal information"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushNamed(Mainpage.routeName);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(EditProfileScreen.routeName);
              },
              child: const CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage(
                    'assets/images/profile_image.png'), // Thêm ảnh asset hoặc ảnh từ mạng
              ),
            ),
            const SizedBox(height: 16),
            Text(
              user.fullName ?? 'N/A',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: user.fullName,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: user.email,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: user.phoneNumber,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: <Widget>[
                Expanded(
                  child: TextFormField(
                    initialValue: user.country,
                    decoration: const InputDecoration(
                      labelText: 'Country',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    initialValue: user.gender,
                    decoration: const InputDecoration(
                      labelText: 'Gender',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: user.address,
              decoration: const InputDecoration(
                labelText: 'Address',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
