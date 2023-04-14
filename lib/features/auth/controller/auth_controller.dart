// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/features/auth/repository/auth_repository.dart';
import 'package:whatsapp_clone/models/user.dart';

final authControllerProvider = Provider((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthController(authRepository: authRepository, ref: ref);
});

final authCheckProvider = FutureProvider((ref) async {
  final authController = ref.watch(authControllerProvider);
  return authController.auth();
});

// final userDataStreamProvider =
//     StreamProvider.autoDispose.family<Future<UserModel>>((ref, String uid) {
//   final authController = ref.watch(authControllerProvider);
//   return authController.userDataTest(uid);
// });
final userDataStreamProvider = StreamProvider<UserModel>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final uid = ref.watch(uidProvider);

  return authRepository.userDataByIdStream(uid);
});

final uidProvider = StateProvider<String>((ref) {
  return '12345';
});

class AuthController {
  final AuthRepository authRepository;
  final ProviderRef ref;
  AuthController({
    required this.authRepository,
    required this.ref,
  });

  Future<UserModel?> auth() async {
    var userData = await authRepository.getCurrentUserData();
    return userData;
  }

  void signInWithPhone(BuildContext context, String phoneNumber) {
    authRepository.signInWithPhone(context, phoneNumber);
  }

  void verifyPhoneNumber(
      BuildContext context, String verificationId, String userOTP) {
    authRepository.verifyOTP(context, verificationId, userOTP);
  }

  void saveUserDataToFirebase(
      BuildContext context, String name, File? profilePic) {
    authRepository.saveUserDataToFirebase(
        context: context, name: name, file: profilePic, ref: ref);
  }

  Stream<UserModel> userDataByIdStream(String uid) {
    return authRepository.userDataByIdStream(uid);
  }

  Future<UserModel> userDataById(String uid) {
    return authRepository.userDataById(uid);
  }

  void changeUserState(bool isOnline) {
    authRepository.changeUserState(isOnline);
  }

  void saveFCMToken(String token) {
    authRepository.saveFCMToken(token);
  }
}
