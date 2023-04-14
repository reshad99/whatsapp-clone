import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageMessage extends StatelessWidget {
  const ImageMessage({required this.message, super.key});
  final String message;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/image-show', arguments: message);
      },
      child: Hero(
        tag: message,
        child: CachedNetworkImage(
          imageUrl: message,
        ),
      ),
    );
  }
}
