import 'package:flutter/material.dart';
import 'package:health_care/mainpage.dart';

import 'icon_btn_with_counter.dart';


class HomeHeader extends StatelessWidget {
  const HomeHeader({
    Key? key,
  }) : super(key: key);

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
                Navigator.of(context).pushNamed(Mainpage.routeName);// Navigate back to the home screen
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
          IconBtnWithCounter(
            svgSrc: "assets/icons/user.svg",
            press: () {},
          ),
        ],
      ),
    );
  }
}
