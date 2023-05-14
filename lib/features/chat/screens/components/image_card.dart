import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_clone/core/enums/message_enum.dart';

class ImageCard extends StatelessWidget {
  const ImageCard({
    super.key,
    required this.size,
    required this.messageType,
    required this.message,
    required this.date,
    required this.isMe,
  });

  final Size size;
  final MessageType messageType;
  final String message;
  final String date;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: size.width - 90),
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/image-show', arguments: message);
            },
            child: Hero(
                tag: message,
                child: AspectRatio(
                  aspectRatio: 3 / 3,
                  child: CachedNetworkImage(
                    imageUrl: message,
                    placeholder: (context, url) => Image.asset(
                      "assets/placeholder-image.jpg",
                      fit: BoxFit.cover,
                    ),
                    fit: BoxFit.cover,
                  ),
                )),
          ),
        ),
        Positioned(
          right: 0,
          bottom: 5,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(date),
              const SizedBox(
                width: 5,
              ),
              if (isMe)
                const Icon(Icons.done_all, color: Colors.white, size: 20),
            ],
          ),
        ),
      ],
    );
  }
}
