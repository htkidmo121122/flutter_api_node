import 'package:flutter/material.dart';
import 'package:health_care/mainpage.dart';
import 'package:health_care/screens/setting_screen/components/Privacy_policy_screen.dart';

import 'package:health_care/screens/info_screen/edit_profile.dart'; // Import the EditProfileScreen

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});
  static String routeName = "/setting";

  @override
  // ignore: library_private_types_in_public_api
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool notificationsOn = true; // Example state for notifications
  String language = 'English'; // Example state for language
  String theme = 'Light mode'; // Example state for theme

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Setting and Information"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pushNamed(Mainpage.routeName);
            },
          ),
          backgroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile Information
            const Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50, // Larger avatar
                    backgroundImage: AssetImage(
                        'assets/images/profile_image.png'), // Placeholder image
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Nguyen Van A',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text('doanflutter@gmail.com | 0898891234'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Settings Options
            Expanded(
              child: Center(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    buildSettingsGroup(
                      context,
                      [
                        buildListTile(
                            context, Icons.person, 'Edit profile information'),
                        buildListTile(
                            context, Icons.notifications, 'Notifications',
                            trailing: Text(
                              notificationsOn ? 'ON' : 'OFF',
                              style: const TextStyle(color: Colors.pink),
                            )),
                        buildListTile(context, Icons.language, 'Language',
                            trailing: Text(
                              language,
                              style: const TextStyle(color: Colors.pink),
                            )),
                      ],
                    ),
                    buildSettingsGroup(
                      context,
                      [
                        buildListTile(context, Icons.security, 'Security'),
                        buildListTile(context, Icons.brightness_6, 'Theme',
                            trailing: Text(
                              theme,
                              style: const TextStyle(color: Colors.pink),
                            )),
                      ],
                    ),
                    buildSettingsGroup(
                      context,
                      [
                        buildListTile(context, Icons.help, 'Help & Support'),
                        buildListTile(
                            context, Icons.contact_mail, 'Contact us'),
                        buildListTile(
                          
                            context, Icons.privacy_tip, 'Privacy policy', destination: PrivacyPolicyScreen(),),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSettingsGroup(BuildContext context, List<Widget> tiles) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: tiles,
      ),
    );
  }

  ListTile buildListTile(BuildContext context, IconData icon, String title,
      {Widget? trailing, Widget? destination}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: trailing ?? const Icon(Icons.arrow_forward_ios),
      onTap: () {
        // Handle on tap if needed
        if (title == 'Edit profile information') {
          Navigator.of(context).pushNamed(EditProfileScreen.routeName);
        } else if (title == 'Notifications') {
          setState(() {
            notificationsOn = !notificationsOn;
          });
        }
        // Add similar logic for other options if needed
        else if (destination != null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destination),
        );
        }
      }
    );
  }
}
