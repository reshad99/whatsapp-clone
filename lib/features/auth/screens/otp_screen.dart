import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/features/auth/controller/auth_controller.dart';

class OtpScreen extends ConsumerWidget {
  const OtpScreen({required this.verificationId, super.key});

  final String verificationId;

  void verifyPhoneNumber(BuildContext context, WidgetRef ref, String userOTP) {
    ref
        .read(authControllerProvider)
        .verifyPhoneNumber(context, verificationId, userOTP);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: const Text('Verifying your number')),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            const Text('We have sent an sms with a code'),
            SizedBox(
              width: size.width * 0.4,
              child: TextField(
                maxLength: 6,
                onChanged: (value) {
                  if (value.length == 6) {
                    verifyPhoneNumber(context, ref, value);
                  }
                },
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                    hintText: '- - - - -', hintStyle: TextStyle(fontSize: 30)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
