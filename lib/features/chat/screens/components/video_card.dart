// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:whatsapp_clone/common/enums/message_enum.dart';
import 'package:whatsapp_clone/features/chat/screens/components/date_and_seen.dart';
import 'package:whatsapp_clone/features/chat/screens/components/video_player.dart';

class VideoCard extends StatefulWidget {
  const VideoCard({
    Key? key,
    required this.size,
    required this.messageType,
    required this.message,
    required this.date,
    required this.isMe,
    required this.isSeen,
  }) : super(key: key);

  final Size size;
  final MessageType messageType;
  final String message;
  final String date;
  final bool isMe;
  final bool isSeen;

  @override
  State<VideoCard> createState() => _VideoCardState();
}

class _VideoCardState extends State<VideoCard> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: size.width - 90),
          child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/image-show',
                    arguments: widget.message);
              },
              child: VideoPlayerWidget(videoUrl: widget.message)),
        ),
        Positioned(
          right: 0,
          bottom: 5,
          child: DateAndSeen(
            date: widget.date,
            isMe: widget.isMe,
            isSeen: widget.isSeen,
          ),
        ),
      ],
    );
  }
}
