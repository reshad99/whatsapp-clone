// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whatsapp_clone/models/user.dart';

class Status {
  final String senderUid;
  final String phoneNumber;
  final UserModel? user;
  final DateTime lastUpdate;
  Status({
    required this.senderUid,
    required this.phoneNumber,
    this.user,
    required this.lastUpdate,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'senderUid': senderUid,
      'phoneNumber': phoneNumber,
      'lastUpdate': lastUpdate.millisecondsSinceEpoch,
    };
  }

  factory Status.fromMap(Map<String, dynamic> map) {
    return Status(
      senderUid: map['senderUid'] as String,
      phoneNumber: map['phoneNumber'] as String,
      lastUpdate: (map['lastUpdate'] as Timestamp).toDate(),
    );
  }

  Status copyWith({
    String? senderUid,
    String? phoneNumber,
    UserModel? user,
    DateTime? lastUpdate,
    List<dynamic>? whoHasSeen,
  }) {
    return Status(
      senderUid: senderUid ?? this.senderUid,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      user: user ?? this.user,
      lastUpdate: lastUpdate ?? this.lastUpdate,
    );
  }
}
