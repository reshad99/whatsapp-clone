import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/common/enums/message_enum.dart';
import 'package:whatsapp_clone/features/auth/controller/auth_controller.dart';

import 'package:whatsapp_clone/features/chat/repository/chat_repository.dart';
import 'package:whatsapp_clone/models/chat_contact.dart';
import 'package:whatsapp_clone/models/message.dart';
import 'package:whatsapp_clone/models/user.dart';

final chatControllerProvider = Provider((ref) {
  final chatRepo = ref.watch(chatRepositoryProvider);
  return ChatController(chatRepository: chatRepo, ref: ref);
});

final chatContactsStreamProvider = StreamProvider<List<ChatContact>>((ref) {
  var chatRepo = ref.watch(chatRepositoryProvider);
  return chatRepo.getChatContacts();
});

final chatMessagesStreamProvider = StreamProvider<List<Message>>((ref) {
  var chatRepo = ref.watch(chatRepositoryProvider);
  return chatRepo.getMessages(ref.watch(uidProvider));
});

final showMicProvider = StateProvider<bool>((ref) {
  return true;
});

final videoPlayedProvider = StateProvider<bool>((ref) {
  return false;
});

final showEmojiProvider = StateProvider<bool>((ref) {
  return false;
});

final textFieldFocusProvider = StateProvider<bool>((ref) {
  return false;
});

class ChatController {
  final ChatRepository chatRepository;
  final ProviderRef ref;
  ChatController({
    required this.chatRepository,
    required this.ref,
  });
  void seeMessages(String senderId) {
    return chatRepository.seeMessages(senderId);
  }

  void selectChatContact(
      BuildContext context, WidgetRef ref, ChatContact contact) {
    chatRepository.selectChatContact(context, ref, contact);
  }

  Stream getUnseenMessageCount(String senderId) {
    return chatRepository.getUnseenMessageCount(senderId);
  }

  Future<UserModel> convertContactToUser(ChatContact contact) {
    return chatRepository.convertContactToUser(contact: contact);
  }

  void sendTextMessage(
    BuildContext context,
    String text,
    String receiverId,
  ) {
    ref.read(authCheckProvider).whenData((value) =>
        chatRepository.sendTextMessage(
            context: context,
            text: text,
            receiverId: receiverId,
            senderUser: value!));
  }

  void sendFileMessage(BuildContext context, File file, String receiverId,
      MessageType messageType) {
    ref.read(authCheckProvider).whenData((value) =>
        chatRepository.sendFileMessage(
            context: context,
            receiverId: receiverId,
            file: file,
            messageType: messageType,
            ref: ref,
            senderUserData: value!));
  }
}
