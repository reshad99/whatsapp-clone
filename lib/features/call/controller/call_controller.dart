import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp_clone/features/auth/controller/auth_controller.dart';
import 'package:whatsapp_clone/features/call/repository/call_repository.dart';
import 'package:whatsapp_clone/models/call.dart';
import 'package:whatsapp_clone/models/user.dart';

final callControllerProvider = Provider((ref) {
  final callRepository = ref.watch(callRepositoryProvider);
  return CallController(
      callRepository: callRepository, ref: ref, auth: FirebaseAuth.instance);
});

class CallController {
  final CallRepository callRepository;
  final ProviderRef ref;
  final FirebaseAuth auth;
  CallController({
    required this.callRepository,
    required this.ref,
    required this.auth,
  });

  Stream<DocumentSnapshot> get callStream => callRepository.callStream;

  void makeCall(BuildContext context, String receiverId,
      String receiverProfilePic, String receiverName) {
    ref.read(authCheckProvider).whenData((user) {
      var callId = const Uuid().v4();
      Call callerData = getCallModel(
          user!, receiverId, receiverProfilePic, receiverName, callId, true);

      Call receiverData = getCallModel(
          user, receiverId, receiverProfilePic, receiverName, callId, false);

      callRepository.makeCall(callerData, receiverData, context);
    });
  }

  Call getCallModel(UserModel user, String receiverId, String receiverProfilePic,
      String receiverName, String callId, bool isDialled) {
    return Call(
        callerId: user.uid,
        callerName: user.name,
        callerPic: user.profilePic,
        receiverId: receiverId,
        receiverName: receiverName,
        receiverPic: receiverProfilePic,
        callId: callId,
        isDialled: isDialled);
  }

  void endCall(String callerId, String receiverId, BuildContext context) {
    return callRepository.endCall(callerId, receiverId, context);
  }
}
