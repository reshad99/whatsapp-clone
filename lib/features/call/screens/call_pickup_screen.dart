import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/core/utils/helpers.dart';
import 'package:whatsapp_clone/features/call/controller/call_controller.dart';
import 'package:whatsapp_clone/features/call/screens/call_screen.dart';
import 'package:whatsapp_clone/models/call.dart';

class CallPickUpScreen extends ConsumerWidget {
  final Widget scaffold;
  const CallPickUpScreen({required this.scaffold, super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<DocumentSnapshot>(
      stream: ref.read(callControllerProvider).callStream,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.data() != null) {
          var callMap = snapshot.data!.data();
          Call callModel = Call.fromMap(callMap as Map<String, dynamic>);
          if (!callModel.isDialled) {
            return Scaffold(
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Incoming Call',
                    style: TextStyle(fontSize: 30, color: Colors.white),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: getProfilePic(callModel.callerPic),
                  ),
                  Text(
                    callModel.callerName,
                    style: const TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                        fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(
                    height: 75,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                          iconSize: 40,
                          onPressed: () {},
                          icon: const Icon(
                            Icons.call_end,
                            color: Colors.red,
                          )),
                      const SizedBox(
                        width: 30,
                      ),
                      IconButton(
                          iconSize: 40,
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CallScreen(
                                      channelId: callModel.callId,
                                      call: callModel),
                                ));
                          },
                          icon: const Icon(
                            Icons.call,
                            color: Colors.green,
                          )),
                    ],
                  )
                ],
              ),
            );
          }
        }
        return scaffold;
      },
    );
  }
}
