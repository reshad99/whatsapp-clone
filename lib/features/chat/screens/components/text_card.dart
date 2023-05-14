// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:whatsapp_clone/core/enums/message_enum.dart';
import 'package:whatsapp_clone/core/utils/helpers.dart';
import 'package:whatsapp_clone/features/chat/screens/components/date_and_seen.dart';

class TextCard extends StatelessWidget {
  const TextCard({
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
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: size.width - 90),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: getMessageFormat(messageType, message),
          ),
        ),
        DateAndSeen(date: date, isMe: isMe, isSeen: isSeen),
      ],
    );
  }
}


