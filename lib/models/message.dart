// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:whatsapp_clone/core/enums/message_enum.dart';

class Message {
  final String receiverId;
  final String senderId;
  final String text;
  final String messageId;
  final MessageType type;
  final DateTime time;
  final bool isSeen;
  Message({
    required this.receiverId,
    required this.senderId,
    required this.messageId,
    required this.text,
    required this.type,
    required this.time,
    required this.isSeen,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'receiverId': receiverId,
      'senderId': senderId,
      'messageId': messageId,
      'text': text,
      'type': type.name,
      'time': time.millisecondsSinceEpoch,
      'isSeen': isSeen,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      receiverId: map['receiverId'] as String,
      senderId: map['senderId'] as String,
      messageId: map['messageId'] as String,
      text: map['text'] as String,
      type: ConvertMessage.fromString(map['type']),
      time: DateTime.fromMillisecondsSinceEpoch(map['time'] as int),
      isSeen: map['isSeen'] as bool,
    );
  }
}
