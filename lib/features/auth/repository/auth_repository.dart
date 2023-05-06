// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp_clone/common/utils/helpers.dart';
import 'package:whatsapp_clone/models/user.dart';
import 'package:whatsapp_clone/services/firebase_storage.dart';
import 'package:whatsapp_clone/services/local_database.dart';
import 'package:whatsapp_clone/services/locator.dart';

final authRepositoryProvider = Provider((ref) {
  return AuthRepository(
      auth: FirebaseAuth.instance, fireStore: FirebaseFirestore.instance);
});

class AuthRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore fireStore;
  AuthRepository({
    required this.auth,
    required this.fireStore,
  });

  Future<UserModel?> getCurrentUserData() async {
    var userData =
        await fireStore.collection('users').doc(auth.currentUser?.uid).get();

    UserModel? userModel;

    if (userData.data() != null) {
      var localDB = getIt<LocalDatabase>();
      localDB.store('auth', userData.data());
      userModel = UserModel.fromMap(userData.data()!);
      debugPrint(userModel.name);
    }
    return userModel;
  }

  void signInWithPhone(BuildContext context, String phoneNumber) async {
    try {
      buildLoader(context);
      await auth.verifyPhoneNumber(
        timeout: const Duration(minutes: 1),
        phoneNumber: phoneNumber,
        verificationCompleted: (phoneAuthCredential) async {
          await auth.signInWithCredential(phoneAuthCredential);
        },
        verificationFailed: (error) {
          debugPrint('Errror cixdi $error');
          throw Exception(error.message);
        },
        codeSent: (verificationId, forceResendingToken) {
          Navigator.pushNamed(context, '/otp-screen',
              arguments: verificationId);
        },
        codeAutoRetrievalTimeout: (verificationId) {},
      );
    } catch (e) {
      showSnackbar(context: context, content: e.toString());
    }
  }

  void verifyOTP(
      BuildContext context, String verificationId, String userOTP) async {
    try {
      buildLoader(context);
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: userOTP);

      await auth.signInWithCredential(credential);

      Future.microtask(() => Navigator.pushNamedAndRemoveUntil(
          context, '/user-info', (route) => false));
    } on FirebaseAuthException catch (e) {
      showSnackbar(context: context, content: e.toString());
      Navigator.pop(context);
    }
  }

  void saveUserDataToFirebase(
      {required BuildContext context,
      required String name,
      required File? file,
      required ProviderRef ref}) async {
    try {
      buildLoader(context);
      String uid = auth.currentUser!.uid;
      String photoUrl = getDefaultProfilePhoto();

      if (file != null) {
        photoUrl = await ref
            .read(firebaseStorageServiceProvider)
            .storeFileToFirebase('profilePic/$uid', file);
      }

      String date = DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now());

      var user = UserModel(
          name: name,
          uid: uid,
          lastUpdate: date,
          profilePic: photoUrl,
          phoneNumber: auth.currentUser!.phoneNumber!,
          isOnline: true,
          token: '',
          groupId: []);

      //save to Local Database
      final localDB = getIt<LocalDatabase>();
      localDB.store('auth', user.toMap());

      await fireStore.collection('users').doc(uid).set(user.toMap());
      Future.microtask(() => Navigator.pushNamedAndRemoveUntil(
          context, '/home', (route) => false));
    } catch (e) {
      showSnackbar(context: context, content: e.toString());
    }
  }

  Stream<UserModel> userDataByIdStream(String uid) {
    return fireStore
        .collection('users')
        .doc(uid)
        .snapshots()
        .map((event) => UserModel.fromMap(event.data()!));
  }

  Future<UserModel> userDataById(String uid) async {
    var collection = await fireStore.collection('users').doc(uid).get();

    return UserModel.fromMap(collection.data()!);
  }

  void changeUserState(bool isOnline) async {
    var lastUpdate = DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now());
    await fireStore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .update({'isOnline': isOnline, 'lastUpdate': lastUpdate});
  }

  Future<void> saveFCMToken(String token) async {
    await fireStore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .update({'token': token});
  }
}
