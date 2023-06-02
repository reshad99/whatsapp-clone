import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/core/utils/helpers.dart';
import 'package:whatsapp_clone/features/call/screens/call_screen.dart';
import 'package:whatsapp_clone/models/call.dart';

final callRepositoryProvider = Provider((ref) {
  return CallRepository(
      auth: FirebaseAuth.instance, fireStore: FirebaseFirestore.instance);
});

class CallRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore fireStore;
  CallRepository({
    required this.auth,
    required this.fireStore,
  });

  Stream<DocumentSnapshot> get callStream =>
      fireStore.collection('call').doc(auth.currentUser!.uid).snapshots();

  void makeCall(
      Call senderCallData, Call receiverCallData, BuildContext context) async {
    try {
      saveCall(senderCallData, receiverCallData);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CallScreen(
                channelId: senderCallData.callId, call: senderCallData),
          ));
    } catch (e) {
      showSnackbar(context: context, content: e.toString());
    }
  }

  void saveCall(Call senderCallData, Call receiverCallData) async {
    await fireStore
        .collection('call')
        .doc(senderCallData.callerId)
        .set(senderCallData.toMap());

    await fireStore
        .collection('call')
        .doc(senderCallData.receiverId)
        .set(receiverCallData.toMap());
  }

  Future<void> deleteCall(String userId) async {
    await fireStore.collection('call').doc(userId).delete();
  }

  void endCall(String callerId, String receiverId, BuildContext context) {
    try {
      deleteCall(callerId);
      deleteCall(receiverId);
    } catch (e) {
      showSnackbar(context: context, content: e.toString());
    }
  }
}
