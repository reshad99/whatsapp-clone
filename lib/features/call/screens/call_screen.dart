// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/config/agora_config.dart';
import 'package:whatsapp_clone/core/widgets/loading_screen.dart';
import 'package:whatsapp_clone/features/call/controller/call_controller.dart';

import 'package:whatsapp_clone/models/call.dart';

class CallScreen extends ConsumerStatefulWidget {
  final String channelId;
  final Call call;
  const CallScreen({
    Key? key,
    required this.channelId,
    required this.call,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CallScreenState();
}

class _CallScreenState extends ConsumerState<CallScreen> {
  AgoraClient? client;

  @override
  void initState() {
    super.initState();
    String baseUrl =
        'https://test.bakudevs.com/generate-agora-token/${widget.channelId}/${widget.call.callerId}';
    client = AgoraClient(
        agoraConnectionData: AgoraConnectionData(
            appId: AgoraConfig.appID,
            channelName: widget.channelId,
            tokenUrl: baseUrl));
    initAgora();
  }

  void initAgora() {
    client!.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return client == null
        ? const LoadingScreen()
        : Scaffold(
            body: SafeArea(
                child: Stack(
              children: [
                AgoraVideoViewer(client: client!),
                AgoraVideoButtons(
                  client: client!,
                  disconnectButtonChild: IconButton(
                    icon: const Icon(
                      Icons.call_end,
                      color: Colors.redAccent,
                    ),
                    onPressed: () async {
                      await client!.engine.leaveChannel();
                      Future.microtask(() {
                        ref.read(callControllerProvider).endCall(
                            widget.call.callerId,
                            widget.call.receiverId,
                            context);
                        Navigator.pop(context);
                      });
                    },
                  ),
                )
              ],
            )),
          );
  }
}
