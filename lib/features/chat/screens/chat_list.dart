import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_list_view/flutter_list_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/core/utils/helpers.dart';
import 'package:whatsapp_clone/core/widgets/custom_error_screen.dart';
import 'package:whatsapp_clone/core/widgets/loading_screen.dart';
import 'package:whatsapp_clone/features/auth/controller/auth_controller.dart';
import 'package:whatsapp_clone/features/chat/controller/chat_controller.dart';
import 'package:whatsapp_clone/features/chat/repository/chat_repository.dart';
import 'package:whatsapp_clone/features/chat/screens/components/message_card.dart';
import 'package:whatsapp_clone/models/message.dart';

class ChatList extends ConsumerStatefulWidget {
  const ChatList({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {
  final FlutterListViewController messageController =
      FlutterListViewController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var messages = ref.watch(chatMessagesStreamProvider);
    var messageStream =
        ref.read(chatRepositoryProvider).getMessages(ref.read(uidProvider));
    ref.read(chatControllerProvider).seeMessages(ref.read(uidProvider));

    // return StreamBuilder<List<Message>>(
    //   stream: messageStream,
    //   builder: (context, snapshot) {
    //     if (snapshot.hasData) {
    //       WidgetsBinding.instance.addPostFrameCallback((_) {
    //         messageController
    //             .jumpTo(messageController.position.maxScrollExtent);
    //       });
    //       return ListView.builder(
    //         physics: const AlwaysScrollableScrollPhysics(),
    //         controller: messageController,
    //         itemCount: snapshot.data!.length,
    //         shrinkWrap: false,
    //         itemBuilder: (context, index) {
    //           var message = snapshot.data![index];

    //           return MessageCard(
    //             messageType: message.type,
    //             seen: message.isSeen,
    //             message: message.text,
    //             isMe: FirebaseAuth.instance.currentUser!.uid == message.senderId
    //                 ? true
    //                 : false,
    //             date: timeForMessage(formatDate(message.time)),
    //           );
    //         },
    //       );
    //     }

    //     return const LoadingScreen();
    //   },
    // );

    return messages.when(
      data: (data) {
        scrollToBottom(messageController, data.length);

        return FlutterListView.builder(
          controller: messageController,
          itemCount: data.length,
          shrinkWrap: false,
          itemBuilder: (context, index) {
            var message = data[index];
            return MessageCard(
              messageType: message.type,
              seen: message.isSeen,
              message: message.text,
              isMe: FirebaseAuth.instance.currentUser!.uid == message.senderId
                  ? true
                  : false,
              date: timeForMessage(formatDate(message.time)),
            );
          },
        );

        // return ListView.builder(
        //   physics: const AlwaysScrollableScrollPhysics(),
        //   controller: messageController,
        //   itemCount: data.length,
        //   shrinkWrap: false,
        //   itemBuilder: (context, index) {
        //     var message = data[index];
        //     return MessageCard(
        //       messageType: message.type,
        //       seen: message.isSeen,
        //       message: message.text,
        //       isMe: FirebaseAuth.instance.currentUser!.uid == message.senderId
        //           ? true
        //           : false,
        //       date: timeForMessage(formatDate(message.time)),
        //     );
        //   },
        // );
      },
      error: (error, stackTrace) {
        return CustomErrorScreen(
          error: error.toString(),
        );
      },
      loading: () {
        return const LoadingScreen();
      },
    );
  }
}
