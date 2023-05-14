import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/core/utils/helpers.dart';
import 'package:whatsapp_clone/core/widgets/custom_button.dart';
import 'package:whatsapp_clone/core/utils/colors.dart';
import 'package:whatsapp_clone/features/auth/controller/auth_controller.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static const routeName = 'login-screen';
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final phoneController = TextEditingController();
  Country? country;

  @override
  void dispose() {
    super.dispose();
    phoneController.dispose();
  }

  void pickCountry() {
    showCountryPicker(
      context: context,
      showPhoneCode:
          true, // optional. Shows phone code before the country name.
      onSelect: (Country countryParameter) {
        setState(() {
          country = countryParameter;
        });
      },
    );
  }

  void sendPhoneNumber() {
    String phoneNumber = phoneController.text.trim();

    if (country != null && phoneNumber.isNotEmpty) {
      ref
          .read(authControllerProvider)
          .signInWithPhone(context, '+${country!.phoneCode}$phoneNumber');
    } else {
      showSnackbar(
          context: context,
          content: 'Fill out all the fields',
          color: greyColor);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        title: const Text('Enter your phone number'),
        backgroundColor: backgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('Whatsapp will need your number to verify'),
            const SizedBox(
              height: 10,
            ),
            TextButton(
                onPressed: () {
                  pickCountry();
                },
                child: const Text('Pick country')),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                if (country != null) Text('+${country!.phoneCode}'),
                const SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: size.width * 0.7,
                  child: TextField(
                    controller: phoneController,
                    decoration: const InputDecoration(hintText: 'phone number'),
                  ),
                )
              ],
            ),
            SizedBox(
              height: size.height * 0.5,
            ),
            SizedBox(
              width: 90,
              child: CustomButton(
                text: 'Next',
                onPressed: () {
                  sendPhoneNumber();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
