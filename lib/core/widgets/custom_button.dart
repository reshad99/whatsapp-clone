import 'package:flutter/material.dart';
import 'package:whatsapp_clone/core/utils/colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final TextStyle? style;
  const CustomButton(
      {this.style, required this.text, required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          backgroundColor: tabColor,
          foregroundColor: backgroundColor,
          minimumSize: const Size(double.infinity, 50)),
      child: Text(
        text,
        style: style,
      ),
    );
  }
}
