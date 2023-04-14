// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp_clone/common/enums/message_enum.dart';
import 'package:whatsapp_clone/common/utils/config.dart';
import 'package:whatsapp_clone/common/utils/helpers.dart';
import 'package:whatsapp_clone/features/auth/controller/auth_controller.dart';
import 'package:whatsapp_clone/models/chat_contact.dart';
import 'package:whatsapp_clone/models/message.dart';
import 'package:whatsapp_clone/models/user.dart';
import 'package:whatsapp_clone/services/api_client.dart';
import 'package:whatsapp_clone/services/firebase_storage.dart';
import 'package:whatsapp_clone/services/locator.dart';

final chatRepositoryProvider = Provider((ref) {
  return ChatRepository(
      firestore: FirebaseFirestore.instance, auth: FirebaseAuth.instance);
});

class ChatRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  ChatRepository({
    required this.firestore,
    required this.auth,
  });

  void seeMessages(String senderId) {
    debugPrint('see Messages tetiklendi. $senderId');
    firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(senderId)
        .collection('messages')
        .where('isSeen', isEqualTo: false)
        .where('senderId', isEqualTo: senderId)
        .get()
        .then((querySnapshots) {
      debugPrint('update started');
      for (var doc in querySnapshots.docs) {
        doc.reference.update({'isSeen': true});
      }
    }).catchError((e) {
      debugPrint('Update Error $e');
    });

    firestore
        .collection('users')
        .doc(senderId)
        .collection('chats')
        .doc(auth.currentUser!.uid)
        .collection('messages')
        .where('isSeen', isEqualTo: false)
        .where('receiverId', isEqualTo: auth.currentUser!.uid)
        .get()
        .then((querySnapshots) {
      for (var doc in querySnapshots.docs) {
        doc.reference.update({'isSeen': true});
      }
    });
  }

  Future<UserModel> convertContactToUser({required ChatContact contact}) async {
    var userData =
        await firestore.collection('users').doc(contact.contactId).get();
    UserModel userModel = UserModel.fromMap(userData.data()!);
    return userModel;
  }

  void selectChatContact(
      BuildContext context, WidgetRef ref, ChatContact contact) async {
    ref.read(uidProvider.notifier).update((state) => contact.contactId);
    final UserModel userModel = await convertContactToUser(contact: contact);
    Future.microtask(() => Navigator.pushNamed(context, '/chat-screen',
        arguments: {'user': userModel}));
  }

  Stream getUnseenMessageCount(String senderId) {
    try {
      final messageCount = firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('chats')
          .doc(senderId)
          .collection('messages')
          .where('senderId', isEqualTo: senderId)
          .where('isSeen', isEqualTo: false)
          .snapshots();
      return messageCount;
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<Message>> getMessages(String receiverId) {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy('time')
        .snapshots()
        .map((event) {
      List<Message> messages = [];
      for (var message in event.docs) {
        messages.add(Message.fromMap(message.data()));
      }
      return messages;
    });
  }

  Stream<List<ChatContact>> getChatContacts() {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .orderBy('timeSent', descending: true)
        .snapshots()
        .map((event) {
      List<ChatContact> contacts = [];
      for (var document in event.docs) {
        var chatContact = ChatContact.fromMap(document.data());
        contacts.add(chatContact);
      }
      return contacts;
    });
  }

  void _saveMessage(
      {required String receiverId,
      required String senderId,
      required DateTime sendTime,
      required String messageId,
      required String text,
      required MessageType type}) async {
    Message message = Message(
        receiverId: receiverId,
        senderId: senderId,
        messageId: messageId,
        text: text,
        type: type,
        time: sendTime,
        isSeen: false);
    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .doc(messageId)
        .set(message.toMap());

    await firestore
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(auth.currentUser!.uid)
        .collection('messages')
        .doc(messageId)
        .set(message.toMap());
  }

  void _saveDataToContactsSubCollection(
      {required UserModel senderUserData,
      required UserModel receiverUserData,
      required String message,
      required DateTime timeSent}) async {
    ChatContact senderUserContact = ChatContact(
        name: receiverUserData.name,
        contactId: receiverUserData.uid,
        profilePic: receiverUserData.profilePic,
        timeSent: timeSent,
        lastMessage: message);
    ChatContact receiverUserContact = ChatContact(
        name: senderUserData.name,
        contactId: senderUserData.uid,
        profilePic: senderUserData.profilePic,
        timeSent: timeSent,
        lastMessage: message);

    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(receiverUserData.uid)
        .set(senderUserContact.toMap());
    await firestore
        .collection('users')
        .doc(receiverUserData.uid)
        .collection('chats')
        .doc(auth.currentUser!.uid)
        .set(receiverUserContact.toMap());
  }

  void sendTextMessage(
      {required BuildContext context,
      required String text,
      required String receiverId,
      required UserModel senderUser}) async {
    try {
      DateTime time = DateTime.now();
      var userDataMap =
          await firestore.collection('users').doc(receiverId).get();

      UserModel receiverUserData = UserModel.fromMap(userDataMap.data()!);
      var messageId = const Uuid().v4();
      _saveDataToContactsSubCollection(
          senderUserData: senderUser,
          receiverUserData: receiverUserData,
          message: text,
          timeSent: time);
      _saveMessage(
          receiverId: receiverId,
          senderId: senderUser.uid,
          sendTime: time,
          messageId: messageId,
          text: text,
          type: MessageType.text);
      _sendPushNotification(
          receiverUserData.token!, senderUser.name, text, senderUser.uid);
    } catch (e) {
      showSnackbar(context: context, content: e.toString());
    }
  }

  void sendFileMessage(
      {required BuildContext context,
      required String receiverId,
      required UserModel senderUserData,
      required ProviderRef ref,
      required File file,
      required MessageType messageType}) async {
    try {
      var timeSent = DateTime.now();
      var messageId = Uuid().v1();
      String imageUrl = await ref
          .read(firebaseStorageServiceProvider)
          .storeFileToFirebase(
              'chat/${senderUserData.uid}/$receiverId/$messageId', file);

      UserModel receiverUserData;
      var userDataMap =
          await firestore.collection('users').doc(receiverId).get();
      receiverUserData = UserModel.fromMap(userDataMap.data()!);
      _saveDataToContactsSubCollection(
          senderUserData: senderUserData,
          receiverUserData: receiverUserData,
          message: messageType.chatText,
          timeSent: timeSent);

      _saveMessage(
          receiverId: receiverId,
          senderId: senderUserData.uid,
          sendTime: timeSent,
          messageId: messageId,
          text: imageUrl,
          type: messageType);
    } catch (e) {
      showSnackbar(content: e.toString(), context: context);
    }
  }

  void _sendPushNotification(
      String token, String name, String messageText, String senderId) async {
    final api = getIt<ApiClient>();
    const url = Config.firebaseUrl;
    const serverKey = Config.firebaseServiceKey;
    var chatId = generateChatId(senderId, auth.currentUser!.uid);
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'key=$serverKey',
    };

    final message = {
      'notification': {
        'title': name,
        'body': messageText,
        'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      },
      'to': token,
      'priority': 'high',
      'data': {
        'type': 'group_message',
        'sender_id': senderId,
        'chat_id': chatId,
        'message': messageText,
      },
    };

    try {
      final response = await api.sendRequest.post(url,
          data: jsonEncode(message), options: Options(headers: headers));
      print('Bildirim gönderildi. Response: ${response.data}');
    } catch (e) {
      print('Bildirim gönderirken hata oluştu: $e');
    }
  }
}
