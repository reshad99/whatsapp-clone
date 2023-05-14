import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp_clone/core/enums/file_type.dart';
import 'package:whatsapp_clone/core/utils/helpers.dart';
import 'package:whatsapp_clone/features/auth/controller/auth_controller.dart';
import 'package:whatsapp_clone/features/select_contacts/controller/select_contacts_controller.dart';
import 'package:whatsapp_clone/models/status.dart';
import 'package:whatsapp_clone/models/story.dart';
import 'package:whatsapp_clone/models/user.dart';
import 'package:whatsapp_clone/services/firebase_storage.dart';

final statusRepositoryProvider = Provider((ref) {
  return StatusRepository(
      FirebaseFirestore.instance, FirebaseAuth.instance, ref);
});

class StatusRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  final ProviderRef ref;

  StatusRepository(this.firestore, this.auth, this.ref);

  Future<void> saveStatus(DateTime time, String senderUid) async {
    try {
      var statusModel = Status(
          lastUpdate: time,
          senderUid: senderUid,
          phoneNumber: auth.currentUser!.phoneNumber!);
      await firestore
          .collection('statuses')
          .doc(senderUid)
          .set(statusModel.toMap());
    } catch (e) {
      if (kDebugMode) {
        debugPrint(e.toString());
      }
    }
  }

  void saveStory({
    required BuildContext context,
    required File file,
    String? text,
  }) async {
    try {
      buildLoader(context);

      var storyId = const Uuid().v4();
      var createdAt = DateTime.now();
      var senderUid = auth.currentUser!.uid;

      FileType fileType;
      var fileExtension = getFileExtension(file.path);
      if (isVideoFile(fileExtension)) {
        fileType = FileType.video;
      } else {
        fileType = FileType.image;
      }

      final docSnapshot =
          await firestore.collection('statuses').doc(senderUid).get();
      if (docSnapshot.exists) {
        await firestore
            .collection('statuses')
            .doc(senderUid)
            .update({'lastUpdate': createdAt.millisecondsSinceEpoch});
      } else {
        await saveStatus(createdAt, senderUid);
      }

      var path = await ref
          .read(firebaseStorageServiceProvider)
          .storeFileToFirebase('/status/$storyId', file);
      Story story = Story(storyId, path, text, createdAt, [], fileType);

      await firestore
          .collection('statuses')
          .doc(senderUid)
          .collection('stories')
          .doc(storyId)
          .set(story.toMap());

      Future.microtask(
          () => Navigator.pushReplacementNamed(context, '/home', arguments: 1));
    } catch (e) {
      if (kDebugMode) {
        debugPrint("hata ciktiiiiiiii $e");
      }
    }
  }

  Future<bool> checkOwnStatuses() async {
    bool checkIfStoryExists = false;
    try {
      var querySnapshot = await firestore
          .collection('statuses')
          .doc(auth.currentUser!.uid)
          .collection('stories')
          .where('createdAt',
              isGreaterThan: DateTime.now()
                  .subtract(const Duration(hours: 24))
                  .millisecondsSinceEpoch)
          .get();

      checkIfStoryExists = querySnapshot.docs.isNotEmpty;
    } catch (e) {
      if (kDebugMode) {
        debugPrint("hata cikdi own statuses $e}");
      }
    }
    return checkIfStoryExists;
  }

  Stream<List<UserModel>> getWhoHasSeen(String statusUid) {
    debugPrint('statusUid $statusUid');
    if (statusUid.isEmpty) {
      statusUid = '212280ce-7457-4ff8-b484-ff9504ff43d1';
    }
    return firestore
        .collection('statuses')
        .doc(auth.currentUser!.uid)
        .collection('stories')
        .doc(statusUid)
        .snapshots()
        .asyncMap((story) async {
      Story storyModel = Story.fromMap(story.data()!);
      List<Future<UserModel?>> futures = [];
      for (var userId in storyModel.whoHasSeen) {
        futures.add(ref.read(authControllerProvider).userDataById(userId));
      }
      List<UserModel?> senderUsers = await Future.wait(futures);
      List<UserModel> users = senderUsers
          .where((user) => user != null)
          .map((user) => user!)
          .toList();
      return users;
    });
  }

  Future<void> viewStory(String statusId, String storyId) async {
    DocumentReference storyRef = firestore
        .collection('statuses')
        .doc(statusId)
        .collection('stories')
        .doc(storyId);
    var story = await storyRef.get();
    Story storyModel = Story.fromMap(story.data() as Map<String, dynamic>);

    if (!storyModel.whoHasSeen.contains(auth.currentUser!.uid)) {
      await storyRef.update({
        'whoHasSeen': FieldValue.arrayUnion([auth.currentUser!.uid])
      });
    }
  }

  Future<List<Status>> getOtherStatuses() async {
    List<Status> statuses = [];
    var hours = DateTime.now()
        .subtract(const Duration(hours: 24))
        .millisecondsSinceEpoch;
    final contacts = await ref.read(getContactsProvider.future);
    try {
      for (var contact in contacts) {
        var phoneNumber = contact!.phones[0].number.replaceAll(' ', '');
        var statusQuery = await firestore
            .collection('statuses')
            .where('lastUpdate', isGreaterThan: hours)
            .get();

        List<Future<UserModel?>> futures = [];
        if (statusQuery.docs.isNotEmpty) {
          for (var doc in statusQuery.docs) {
            final status = Status.fromMap(doc.data());
            if (status.phoneNumber == phoneNumber &&
                status.senderUid != auth.currentUser!.uid) {
              futures.add(
                ref.read(authControllerProvider).userDataById(status.senderUid),
              );
            }
          }
          List<UserModel?> senderUsers = await Future.wait(futures);
          for (int i = 0; i < statusQuery.docs.length; i++) {
            final status = Status.fromMap(statusQuery.docs[i].data());
            final statusAttachment = status.copyWith(
              user: senderUsers[i],
            );
            statuses.add(statusAttachment);
          }
        } else {
          debugPrint('Statuses are empty');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('get other statuses error $e');
      }
    }
    return statuses;
  }

  Future<List<Story>> getStoriesByStatus(
      {required BuildContext context, required String statusId}) async {
    List<Story> stories = [];
    try {
      var storyQuery = await firestore
          .collection('statuses')
          .doc(statusId)
          .collection('stories')
          .where('createdAt',
              isGreaterThan: DateTime.now()
                  .subtract(const Duration(hours: 24))
                  .millisecondsSinceEpoch)
          .get();

      for (var story in storyQuery.docs) {
        Story storyModel = Story.fromMap(story.data());
        stories.add(storyModel);
      }
    } catch (e) {
      showSnackbar(context: context, content: e.toString());
    }
    return stories;
  }

  // Future<List<Status>> getOtherStatuses() async {
  //   List<Status> statuses = [];
  //   try {
  //     await firestore
  //         .collection('statuses')
  //         .where('senderUid', isNotEqualTo: auth.currentUser!.uid)
  //         .get()
  //         .then((value) {
  //       for (var doc in value.docs) {
  //         final status = Status.fromMap(doc.data());
  //         ref
  //             .read(authControllerProvider)
  //             .userData(status.senderUid)
  //             .then((senderUser) {
  //           final statusAttachment = status.copyWith(
  //               fileType: status.fileType,
  //               senderUid: status.senderUid,
  //               lastUpdate: status.lastUpdate,
  //               text: status.text,
  //               uid: status.uid,
  //               url: status.url,
  //               user: senderUser,
  //               whoHasSeen: status.whoHasSeen);
  //           statuses.add(statusAttachment);
  //         });
  //       }
  //     });
  //   } catch (e) {
  //     if (kDebugMode) {
  //       debugPrint(e.toString());
  //     }
  //   }
  //   return statuses;
  // }
}
