import 'package:flutter/material.dart';
import 'package:health_care/constants.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        title: const Text(
          "Privacy Policy",
          style: TextStyle(fontWeight: FontWeight.bold, color: kPrimaryColor),
        ),
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
          top: true,
          child: ListView(
            padding: EdgeInsets.zero,
            scrollDirection: Axis.vertical,
            children: const [
              Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '1. Types data we collect',
                      style: TextStyle(
                      fontWeight: FontWeight.w600, color: kPrimaryColor, fontSize: 20),
                    ),
                    Text(
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. \n\nDuis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident.',
                      style: TextStyle(
                      fontWeight: FontWeight.w400, color: kPrimaryColor),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(15),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '2. Use of your personal data',
                      style: TextStyle(
                      fontWeight: FontWeight.w600, color: kPrimaryColor, fontSize: 20),
                    ),
                    Text(
                      'Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae.\n\nNemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit.',
                      style: TextStyle(
                      fontWeight: FontWeight.w400, color: kPrimaryColor),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '3. Disclosure of your personal data',
                      style: TextStyle(
                      fontWeight: FontWeight.w600, color: kPrimaryColor, fontSize: 20),
                    ),
                    Text(
                      'At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident, similique sunt in culpa qui officia deserunt mollitia animi, id est laborum et dolorum fuga. \n\nEt harum quidem rerum facilis est et expedita distinctio. Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit quo minus id quod maxime placeat facere possimus, omnis voluptas assumenda est, omnis dolor repellendus. \n\nTemporibus autem quibusdam et aut officiis debitis aut rerum necessitatibus saepe eveniet ut et voluptates repudiandae sint et molestiae non recusandae. Itaque earum rerum hic tenetur a sapiente delectus',
                      style: TextStyle(
                      fontWeight: FontWeight.w400, color: kPrimaryColor),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
  }
}
