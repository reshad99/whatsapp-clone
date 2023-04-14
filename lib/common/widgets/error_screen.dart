import 'package:flutter/material.dart';
import 'package:whatsapp_clone/common/utils/colors.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: const Text('Error'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [Text('404 Not Found')],
      ),
    );
  }
}
