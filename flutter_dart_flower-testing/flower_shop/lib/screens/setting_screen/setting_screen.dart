import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:health_care/mainpage.dart';
import 'package:health_care/screens/setting_screen/components/Privacy_policy_screen.dart';
import 'package:health_care/screens/info_screen/edit_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});
  static String routeName = "/setting";

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool notificationsOn = true;
  String language = 'English';
  String theme = 'Light mode';

  String userName = 'None';
  String userEmail = '';
  String userPhone = '';
  String? userImage64;
  Uint8List? userImage;
  bool isAdmin = false;  // Thêm biến trạng thái isAdmin

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userDataString = prefs.getString('user_data');
    if (userDataString != null) {
      Map<String, dynamic> userData = jsonDecode(userDataString);
      setState(() {
        userName = userData['name'] ?? 'none';
        userEmail = userData['email'];
        userPhone = '0${userData['phone'] ?? ''}';
        userImage64 = userData['avatar'];
        isAdmin = userData['isAdmin'] ?? false; // Lấy giá trị isAdmin
        if(userImage64 != null){
          String base64String = userImage64!;
          String base64Image = base64String.split(',').last;
          userImage = Uint8List.fromList(base64.decode(base64Image));
        }
        
      });
    } 
  }

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
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: userImage != null
                        ? MemoryImage(userImage!)
                        : const AssetImage('assets/images/profile_image.png') as ImageProvider,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    userName,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text('$userEmail | $userPhone'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Center(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    if (isAdmin) // Hiển thị mục "Quản lý hệ thống" nếu là quản trị viên
                      buildSettingsGroup(
                        context,
                        [
                          buildListTile(context, Icons.admin_panel_settings,
                              'Quản lý hệ thống'),
                        ],
                      ),
                    buildSettingsGroup(
                      context,
                      [
                        buildListTile(context, Icons.person,
                            'Edit profile information'),
                        buildListTile(context, Icons.notifications,
                            'Notifications',
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
                        buildListTile(context, Icons.contact_mail, 'Contact us'),
                        buildListTile(context, Icons.privacy_tip,
                            'Privacy policy',
                            destination: PrivacyPolicyScreen()),
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
        if (title == 'Edit profile information') {
          Navigator.of(context).pushNamed(EditProfileScreen.routeName);
        } else if (title == 'Notifications') {
          setState(() {
            notificationsOn = !notificationsOn;
          });
        } else if (destination != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => destination),
          );
        }
      },
    );
  }
}
