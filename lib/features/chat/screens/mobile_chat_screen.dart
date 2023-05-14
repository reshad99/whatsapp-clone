import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/core/utils/colors.dart';
import 'package:whatsapp_clone/core/utils/helpers.dart';
import 'package:whatsapp_clone/features/auth/controller/auth_controller.dart';
import 'package:whatsapp_clone/models/user.dart';
import 'package:whatsapp_clone/features/chat/screens/chat_list.dart';
import 'package:whatsapp_clone/features/chat/screens/components/chat_textfield.dart';

class MobileChatScreen extends ConsumerWidget {
  const MobileChatScreen({required this.user, super.key});
  final UserModel user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userData = ref.watch(userDataStreamProvider);
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: appBarColor,
        leading: InkWell(
          borderRadius: BorderRadius.circular(50),
          onTap: () {
            Navigator.pop(context);
          },
          child: Row(
            children: [
              const Icon(Icons.arrow_back_outlined),
              CircleAvatar(
                radius: 14,
                backgroundImage: getProfilePic(user.profilePic),
              ),
            ],
          ),
        ),
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user.name),
                  userData.when(
                    data: (data) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          data.isOnline
                              ? 'Online'
                              : "Last seen ${timeDifference(data.lastUpdate!)}",
                          style: const TextStyle(fontSize: 10),
                        ),
                      );
                    },
                    error: (error, stackTrace) {
                      Future.delayed(const Duration(seconds: 4));
                      return const SizedBox();
                    },
                    loading: () {
                      return const SizedBox();
                    },
                  ),
                  // StreamBuilder<UserModel>(
                  //     stream: ref
                  //         .read(authControllerProvider)
                  //         .userDataById(user.uid),
                  //     builder: (context, snapshot) {
                  //       if (snapshot.connectionState ==
                  //           ConnectionState.waiting) {
                  //         return const LoadingScreen();
                  //       }
                  //       return Text(
                  //         snapshot.data!.isOnline
                  //             ? 'Online'
                  //             : "Last seen ${snapshot.data!.lastUpdate!}",
                  //         style: const TextStyle(fontSize: 10),
                  //       );
                  //     })
                ],
              ),
            )
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {}, icon: const Icon(Icons.videocam_rounded)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.phone)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
        ],
      ),
      body: Column(
        children: [
          const Expanded(child: ChatList()),
          MobileTextField(
            receiverId: user.uid,
          )
        ],
      ),
    );
  }
}
