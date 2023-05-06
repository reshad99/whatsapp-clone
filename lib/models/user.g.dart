// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 1;

  @override
  UserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserModel(
      name: fields[2] as String,
      uid: fields[5] as String,
      profilePic: fields[4] as String,
      phoneNumber: fields[3] as String,
      isOnline: fields[1] as bool,
      lastUpdate: fields[6] as String?,
      groupId: (fields[0] as List).cast<String>(),
      token: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.groupId)
      ..writeByte(1)
      ..write(obj.isOnline)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.phoneNumber)
      ..writeByte(4)
      ..write(obj.profilePic)
      ..writeByte(5)
      ..write(obj.uid)
      ..writeByte(6)
      ..write(obj.lastUpdate)
      ..writeByte(7)
      ..write(obj.token);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
