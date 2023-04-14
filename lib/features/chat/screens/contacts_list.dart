import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/common/utils/colors.dart';
import 'package:whatsapp_clone/common/utils/helpers.dart';
import 'package:whatsapp_clone/common/widgets/custom_error_screen.dart';
import 'package:whatsapp_clone/common/widgets/loading_screen.dart';
import 'package:whatsapp_clone/features/chat/controller/chat_controller.dart';

class ContactsList extends ConsumerWidget {
  const ContactsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var chatContacts = ref.watch(chatContactsStreamProvider);
    var chatController = ref.watch(chatControllerProvider);
    return Padding(
        padding: const EdgeInsets.only(top: 5),
        child: chatContacts.when(
          data: (data) {
            return ListView.builder(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                var contact = data[index];
                return InkWell(
                  onTap: () async {
                    chatController.selectChatContact(context, ref, contact);
                  },
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                              backgroundImage:
                                  getProfilePic(contact.profilePic)),
                          title: Text(
                            contact.name,
                            style: const TextStyle(fontSize: 18),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              contact.lastMessage,
                              style: const TextStyle(fontSize: 15),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          trailing: StreamBuilder<dynamic>(
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  if (snapshot.requireData.size > 0) {
                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          timeDifference(
                                              formatDate(contact.timeSent)),
                                          style:
                                              const TextStyle(color: tabColor),
                                        ),
                                        CircleAvatar(
                                          radius: 12,
                                          backgroundColor: tabColor,
                                          child: Text(
                                            snapshot.requireData.size.toString(),
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 13),
                                          ),
                                        )
                                      ],
                                    );
                                  }
                                }

                                return Text(timeDifference(
                                    formatDate(contact.timeSent)));
                              },
                              stream: chatController
                                  .getUnseenMessageCount(contact.contactId)),
                        ),
                      ),
                    ],
                  ),
                );
              },
              itemCount: data.length,
            );
          },
          error: (error, stackTrace) {
            return CustomErrorScreen(error: error.toString());
          },
          loading: () {
            return const LoadingScreen();
          },
        ));
  }
}
