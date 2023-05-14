import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_clone/core/widgets/zoom_image.dart';

class ImageShow extends StatefulWidget {
  const ImageShow({required this.url, super.key});
  final String url;

  @override
  State<ImageShow> createState() => _ImageShowState();
}

class _ImageShowState extends State<ImageShow> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: ZoomImage(imageUrl: widget.url),
      ),
    );
  }
}
