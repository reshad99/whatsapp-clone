import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whatsapp_clone/core/widgets/custom_button.dart';
import 'package:whatsapp_clone/core/utils/colors.dart';
import 'package:whatsapp_clone/core/utils/style.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 40,
          ),
          const Text(
            'Welcome to Whatsapp',
            style: TextStyle(fontSize: 30),
          ),
          SizedBox(
            height: size.height * landingScreenSpacing,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Image.asset(
              'assets/bg.png',
              height: 350.h,
              width: 370,
              color: tabColor,
            ),
          ),
          SizedBox(
            height: size.height * landingScreenSpacing,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: landingScreenPadding),
            child: Text(
              'Lorem ipsum dolor sit amer lorem ipsum dolor sit lorem ipsum dolor sit',
              style: TextStyle(color: greyColor),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: size.height * landingScreenSpacing,
          ),
          SizedBox(
            width: size.width * 0.75,
            child: CustomButton(
              text: "AGREE AND CONTINUE",
              onPressed: () {
                return navigateToLoginScreen(context);
              },
              style: const TextStyle(fontSize: 16),
            ),
          )
        ],
      )),
    );
  }

  void navigateToLoginScreen(BuildContext context) {
    Navigator.pushNamed(context, '/login-screen');
  }
}
