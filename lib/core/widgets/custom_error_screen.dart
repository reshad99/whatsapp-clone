import 'package:flutter/material.dart';

class CustomErrorScreen extends StatelessWidget {
  final String error;
  const CustomErrorScreen({required this.error, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(error),
      ),
    );
  }
}
