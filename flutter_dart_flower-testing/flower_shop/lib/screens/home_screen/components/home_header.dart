import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:health_care/mainpage.dart';
import 'package:health_care/screens/home_screen/components/icon_btn_with_counter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeHeader extends StatefulWidget {
  const HomeHeader({
    Key? key,
  }) : super(key: key);

  @override
  _HomeHeaderState createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  Uint8List? userImage;

  @override
  void initState() {
    super.initState();
    loadUserImage();
  }

  Future<void> loadUserImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userDataString = prefs.getString('user_data');

    if (userDataString != null) {
      Map<String, dynamic> userData = jsonDecode(userDataString);
      if(userData['avatar'] != null){
        String base64String = userData['avatar'].toString() ?? '';
        String base64Image = base64String.split(',').last;
        setState(() {
          userImage = Uint8List.fromList(base64.decode(base64Image));
        });
      }else{
        setState(() {
          userImage = null;
        });
      }
      
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                Navigator.of(context).pushNamed(Mainpage.routeName);
              },
              child: const Text(
                'Flora`s',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          IconBtnWithCounter(
            svgSrc: "assets/icons/bell.svg",
            numOfitem: 3,
            press: () {},
          ),
          const SizedBox(width: 8),
          InkWell(
            onTap: () {},
            child: CircleAvatar(
              radius: 20,
              backgroundImage: userImage != null
                  ? MemoryImage(userImage!)
                  : const AssetImage('assets/images/profile_image.png') as ImageProvider,
            ),
          ),
        ],
      ),
    );
  }
}
