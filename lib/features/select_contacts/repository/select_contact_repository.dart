// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/common/utils/helpers.dart';
import 'package:whatsapp_clone/features/auth/controller/auth_controller.dart';
import 'package:whatsapp_clone/models/user.dart';

final selectContactRepositoryProvider = Provider((ref) {
  return SelectContactRepository(firestore: FirebaseFirestore.instance);
});

class SelectContactRepository {
  SelectContactRepository({
    required this.firestore,
  });

  final FirebaseFirestore firestore;

  Future<List<Contact?>> getContacts() async {
    List<Contact?> selectedContacts = [];
    debugPrint('getContacts girildi');
    try {
      if (await FlutterContacts.requestPermission()) {
        List<Contact> contacts =
            await FlutterContacts.getContacts(withProperties: true);
          debugPrint(contacts.toString());


        selectedContacts = await Future.wait(contacts.map((contact) async {
          var bool = await contactCheck(contact);
          if (bool) {
            return contact;
          } else {
            return null;
          }
        }));
        selectedContacts =
            selectedContacts.where((contact) => contact != null).toList();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return selectedContacts;
  }

  Future<bool> contactCheck(Contact selectedContact) async {
    try {
      var userCollection = await firestore.collection('users').get();
      for (var document in userCollection.docs) {
        var userData = UserModel.fromMap(document.data());
        String selectedPhoneNumber =
            selectedContact.phones[0].number.replaceAll(' ', '');

        if (selectedPhoneNumber == userData.phoneNumber) {
          return true;
        }
      }
    } catch (e) {
      // showSnackbar(context: context, content: e.toString());
    }
    return false;
  }

  void selectContact(
      BuildContext context, Contact selectedContact, WidgetRef ref) async {
    try {
      var userCollection = await firestore.collection('users').get();
      bool isFound = false;

      for (var document in userCollection.docs) {
        var userData = UserModel.fromMap(document.data());
        String selectedPhoneNumber =
            selectedContact.phones[0].number.replaceAll(' ', '');

        if (selectedPhoneNumber == userData.phoneNumber) {
          isFound = true;
          ref.read(uidProvider.notifier).update((state) => userData.uid);
          Future.microtask(() => Navigator.pushNamed(context, '/chat-screen',
              arguments: {'user': userData}));
        }
      }

      if (!isFound) {
        Future.microtask(() => showSnackbar(
            context: context,
            content: "This number doesn't exist on this app"));
      }
    } catch (e) {
      showSnackbar(context: context, content: e.toString());
    }
  }
}
