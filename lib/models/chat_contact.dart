class ChatContact {
  final String name;
  final String contactId;
  final String profilePic;
  final DateTime timeSent;
  final String lastMessage;
  ChatContact({
    required this.name,
    required this.contactId,
    required this.profilePic,
    required this.timeSent,
    required this.lastMessage,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'contactId': contactId,
      'profilePic': profilePic,
      'timeSent': timeSent.millisecondsSinceEpoch,
      'lastMessage': lastMessage,
    };
  }

  factory ChatContact.fromMap(Map<String, dynamic> map) {
    return ChatContact(
      name: map['name'] as String,
      contactId: map['contactId'] as String,
      profilePic: map['profilePic'] as String,
      timeSent: DateTime.fromMillisecondsSinceEpoch(map['timeSent'] as int),
      lastMessage: map['lastMessage'] as String,
    );
  }
}
