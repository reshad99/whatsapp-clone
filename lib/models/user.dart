class UserModel {
  UserModel({
    required this.name,
    required this.uid,
    required this.profilePic,
    required this.phoneNumber,
    required this.isOnline,
    required this.lastUpdate,
    required this.groupId,
    required this.token,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      token: map['token'] as String?,
      name: map['name'] as String,
      uid: map['uid'] as String,
      profilePic: map['profilePic'] as String,
      phoneNumber: map['phoneNumber'] as String,
      lastUpdate: map['lastUpdate'] as String,
      isOnline: map['isOnline'] as bool,
      groupId: List<String>.from((map['groupId'] as List<dynamic>)),
    );
  }

  final List<String> groupId;
  final bool isOnline;
  final String name;
  final String phoneNumber;
  final String profilePic;
  final String uid;
  final String? lastUpdate;
  final String? token;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'token': token,
      'uid': uid,
      'profilePic': profilePic,
      'phoneNumber': phoneNumber,
      'isOnline': isOnline,
      'lastUpdate': lastUpdate,
      'groupId': groupId,
    };
  }
}
