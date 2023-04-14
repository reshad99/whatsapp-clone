import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whatsapp_clone/common/enums/message_enum.dart';
import 'package:whatsapp_clone/common/utils/colors.dart';
import 'package:whatsapp_clone/common/utils/helpers.dart';
import 'package:whatsapp_clone/features/chat/screens/components/image_card.dart';
import 'package:whatsapp_clone/features/chat/screens/components/text_card.dart';
import 'package:whatsapp_clone/models/message.dart';

class MessageCard extends StatelessWidget {
  final bool isMe;
  final bool seen;
  final String message;
  final String date;
  final MessageType messageType;
  const MessageCard(
      {required this.messageType,
      required this.seen,
      required this.date,
      required this.message,
      required this.isMe,
      super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        SizedBox(
          child: Card(
            color: isMe ? messageColor : senderMessageColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: getMessageCard(messageType, message, size, date, isMe, seen ),
          ),
        ),
      ],
    );

    // return Align(
    //     alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
    //     child: ConstrainedBox(
    //       constraints: BoxConstraints(maxWidth: size.width - 45),
    //       child: Card(
    //         elevation: 1,
    //         margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
    //         color: isMe ? messageColor : senderMessageColor,
    //         shape:
    //             RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    //         child: Stack(children: [
    //           Padding(
    //             padding: const EdgeInsets.only(
    //                 left: 10, right: 30, top: 5, bottom: 20),
    //             child: Text(
    //               message,
    //               style: const TextStyle(fontSize: 16),
    //             ),
    //           ),
    //           Positioned(
    //               bottom: 4,
    //               right: 10,
    //               child: Row(
    //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                 children: [
    //                   Text(
    //                     date,
    //                     style: const TextStyle(
    //                         fontSize: 13, color: Colors.white60),
    //                   ),
    //                   SizedBox(
    //                     width: isMe ? 5 : 0,
    //                   ),
    //                   isMe
    //                       ? const Icon(
    //                           Icons.done_all,
    //                           size: 20,
    //                           color: Colors.white60,
    //                         )
    //                       : const SizedBox()
    //                 ],
    //               ))
    //         ]),
    //       ),
    //     ));
  }
}
