import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/core/utils/colors.dart';
import 'package:whatsapp_clone/core/utils/helpers.dart';
import 'package:whatsapp_clone/features/auth/controller/auth_controller.dart';
import 'package:whatsapp_clone/features/status/controller/status_controller.dart';
import 'package:whatsapp_clone/models/story.dart';
import 'package:whatsapp_clone/models/user.dart';

class StatusItem extends ConsumerWidget {
  StatusItem({
    Key? key,
    required this.isFirst,
    required this.uid,
    required this.profilePic,
    required this.name,
    required this.lastUpdate,
  }) : super(key: key);
  final String profilePic;
  final String name;
  final String lastUpdate;
  final String uid;
  final bool isFirst;

  List<Story> stories = [];
  UserModel? user;

  void getStories(WidgetRef ref, BuildContext context) async {
    stories = await ref
        .read(statusControllerProvider)
        .getStoriesByStatusId(context, uid);
    user = await ref.read(authControllerProvider).userDataById(uid);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    getStories(ref, context);
    return InkWell(
      onTap: () async {
        if (isFirst) {
          return selectImageForStatus(context);
        } else {
          ref.read(currentStatusUidProvider.notifier).update((state) => uid);
          Future.microtask(() => Navigator.pushNamed(context, '/story-view',
              arguments: {'stories': stories, 'user': user}));
        }
      },
      child: ListTile(
        leading: Container(
          decoration: BoxDecoration(
              border: Border.all(
                  color: tabColor,
                  width: 3,
                  style: !isFirst ? BorderStyle.solid : BorderStyle.none),
              borderRadius: BorderRadius.circular(100)),
          child: Stack(
            children: [
              CircleAvatar(
                backgroundImage: getProfilePic(profilePic),
                radius: 22,
              ),
              isFirst
                  ? Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: tabColor),
                        width: 20,
                        height: 20,
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    )
                  : const SizedBox()
            ],
          ),
        ),
        title: Text(name),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(
            lastUpdate,
            style: const TextStyle(color: greyColor),
          ),
        ),
      ),
    );
  }
}
