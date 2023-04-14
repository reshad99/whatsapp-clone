// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobileLayoutScreen;
  final Widget webLayoutScreen;
  const ResponsiveLayout({
    Key? key,
    required this.mobileLayoutScreen,
    required this.webLayoutScreen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (p0, p1) {
        if (p1.maxWidth > 900) {
          return webLayoutScreen;
        }

        return mobileLayoutScreen;
      },
    );
  }
}
