// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:whatsapp_clone/core/enums/file_type.dart';

class Story {
  final String uid;
  final String url;
  final String? text;
  final DateTime createdAt;
  final List<dynamic> whoHasSeen;
  final FileType fileType;

  Story(
    this.uid,
    this.url,
    this.text,
    this.createdAt,
    this.whoHasSeen,
    this.fileType,
  );

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'url': url,
      'text': text,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'whoHasSeen': whoHasSeen,
      'fileType': fileType.name,
    };
  }

  factory Story.fromMap(Map<String, dynamic> map) {
    return Story(
      map['uid'] as String,
      map['url'] as String,
      map['text'] != null ? map['text'] as String : null,
      DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      List<dynamic>.from((map['whoHasSeen'] as List<dynamic>)),
      ConvertFile.fromString(map['fileType']),
    );
  }
}
