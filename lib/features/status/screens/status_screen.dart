// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:whatsapp_clone/core/enums/file_type.dart';
import 'package:whatsapp_clone/core/utils/colors.dart';
import 'package:whatsapp_clone/core/utils/helpers.dart';
import 'package:whatsapp_clone/core/widgets/loading_screen.dart';
import 'package:whatsapp_clone/features/auth/controller/auth_controller.dart';
import 'package:whatsapp_clone/features/status/controller/status_controller.dart';
import 'package:whatsapp_clone/features/status/screens/components/status_item.dart';
import 'package:whatsapp_clone/models/status.dart';
import 'package:whatsapp_clone/models/user.dart';
import 'package:whatsapp_clone/services/local_database.dart';
import 'package:whatsapp_clone/services/locator.dart';

class StatusScreen extends ConsumerStatefulWidget {
  const StatusScreen({super.key});

  @override
  ConsumerState<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends ConsumerState<StatusScreen> {
  @override
  Widget build(BuildContext context) {
    final authController = ref.watch(authControllerProvider);
    final statusController = ref.watch(statusControllerProvider);
    final localDB = getIt<LocalDatabase>();
    return FutureBuilder(
      initialData: UserModel.fromMap(localDB.get('auth')),
      future: authController.auth(),
      builder: (context, snapshot) {
        UserModel? userData;
        if (snapshot.hasData) {
          userData = snapshot.data;
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder<bool>(
              future: statusController.checkOwnStatuses(),
              builder: (context, snapshot) {
                bool isFirst = true;
                if (snapshot.hasData) {
                  isFirst = !snapshot.data!;
                }
                return StatusItem(
                  uid: FirebaseAuth.instance.currentUser!.uid,
                  isFirst: isFirst,
                  lastUpdate: 'Tap to add status update',
                  name: 'My Status',
                  profilePic: userData!.profilePic,
                );
              },
            ),
            const Padding(
              padding: EdgeInsets.only(left: 15, top: 10),
              child: Text(
                'Recent updates',
                style: TextStyle(color: greyColor),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Status>>(
                future: statusController.getOtherStatuses(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const SizedBox();
                  }
                  final statuses = snapshot.data!;
                  return ListView.builder(
                    itemBuilder: (context, index) {
                      final status = statuses[index];
                      return StatusItem(
                        uid: status.senderUid,
                        isFirst: false,
                        profilePic: status.user!.profilePic,
                        name: status.user!.name,
                        lastUpdate: formatDate(status.lastUpdate),
                      );
                    },
                    itemCount: statuses.length,
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
