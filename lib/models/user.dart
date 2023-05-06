import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 1, adapterName: 'UserAdapter')
class UserModel extends HiveObject {
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

  @HiveField(0)
  final List<String> groupId;
  @HiveField(1)
  final bool isOnline;
  @HiveField(2)
  final String name;
  @HiveField(3)
  final String phoneNumber;
  @HiveField(4)
  final String profilePic;
  @HiveField(5)
  final String uid;
  @HiveField(6)
  final String? lastUpdate;
  @HiveField(7)
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

  UserModel copyWith({
    List<String>? groupId,
    bool? isOnline,
    String? name,
    String? phoneNumber,
    String? profilePic,
    String? uid,
    String? lastUpdate,
    String? token,
  }) {
    return UserModel(
      groupId: groupId ?? this.groupId,
      isOnline: isOnline ?? this.isOnline,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profilePic: profilePic ?? this.profilePic,
      uid: uid ?? this.uid,
      lastUpdate: lastUpdate ?? this.lastUpdate,
      token: token ?? this.token,
    );
  }
}
