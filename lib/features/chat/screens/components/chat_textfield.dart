import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:whatsapp_clone/core/enums/file_type.dart';
import 'package:whatsapp_clone/core/enums/message_enum.dart';
import 'package:whatsapp_clone/core/utils/colors.dart';
import 'package:whatsapp_clone/core/utils/helpers.dart';
import 'package:whatsapp_clone/features/auth/controller/auth_controller.dart';
import 'package:whatsapp_clone/features/chat/controller/chat_controller.dart';
import 'package:whatsapp_clone/features/chat/screens/components/animated_mic_icon.dart';

class MobileTextField extends ConsumerStatefulWidget {
  const MobileTextField({required this.receiverId, super.key});

  final String receiverId;

  @override
  ConsumerState<MobileTextField> createState() => _MobileTextFieldState();
}

class _MobileTextFieldState extends ConsumerState<MobileTextField> {
  var controller = TextEditingController();
  late FlutterSoundRecorder? flutterSoundRecorder;
  var focusNode = FocusNode();
  bool isRecorderInit = false;
  bool showEmoji = false;
  bool showMic = true;
  bool isRecording = false;

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
    focusNode.dispose();
    flutterSoundRecorder!.closeRecorder();
  }

  @override
  void initState() {
    super.initState();
    flutterSoundRecorder = FlutterSoundRecorder();
    openAudio();
  }

  void sendTextMessage() async {
    if (!ref.read(showMicProvider)) {
      ref
          .read(chatControllerProvider)
          .sendTextMessage(context, controller.text, widget.receiverId);
      controller.text = '';
      changeMicState(true);
    }
  }

  void sendAudioMessage({bool stop = false}) async {
    if (!isRecorderInit) {
      return;
    }
    var tempDir = await getTemporaryDirectory();
    var path = '${tempDir.path}/flutter_sound.aac';
    if (flutterSoundRecorder!.isRecording) {
      await flutterSoundRecorder!.stopRecorder();
      if (!stop) {
        sendFileMessage(File(path), MessageType.audio);
      }
    } else {
      await flutterSoundRecorder!.startRecorder(toFile: path);
    }

    setState(() {});
  }

  void sendFileMessage(File file, MessageType messageType) {
    var receiverId = ref.read(uidProvider);
    ref
        .read(chatControllerProvider)
        .sendFileMessage(context, file, receiverId, messageType);
  }

  void selectImage() async {
    File? image = await pickFileFromGallery(context, FileType.image);
    if (image != null) {
      sendFileMessage(image, MessageType.image);
    }
  }

  void selectVideo() async {
    File? video = await pickFileFromGallery(context, FileType.video);
    if (video != null) {
      sendFileMessage(video, MessageType.video);
    }
  }

  void changeMicState(bool newValue) {
    ref.read(showMicProvider.notifier).update((state) => newValue);
  }

  void openAudio() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw Exception('Mic permission not allowed');
    }
    await flutterSoundRecorder!.openRecorder();
    await flutterSoundRecorder!
        .setSubscriptionDuration(Duration(milliseconds: 500));
    isRecorderInit = true;
  }

  buildMicButton(Size size) {
    return Row(
      children: [
        flutterSoundRecorder!.isRecording
            ? GestureDetector(
                onTap: () {
                  changeMicState(true);
                  sendAudioMessage();
                },
                child: Container(
                  height: size.height * 0.07,
                  width: size.width * 0.13,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: messageColor,
                  ),
                  child: const Icon(
                    Icons.send,
                    size: 25,
                  ),
                ),
              )
            : const SizedBox(),
        const SizedBox(
          width: 5,
        ),
        GestureDetector(
          onLongPress: () {
            debugPrint('long press basladi');
            changeMicState(false);
            sendAudioMessage();
          },
          onLongPressEnd: (details) {
            // changeMicState(true);
            // sendAudioMessage();
          },
          onTap: () {
            if (flutterSoundRecorder!.isRecording) {
              changeMicState(true);
              sendAudioMessage(stop: true);
              return;
            }
            sendTextMessage();
          },
          onVerticalDragUpdate: (details) async {
            debugPrint('drag basladi');
          },
          onVerticalDragEnd: (details) {
            sendAudioMessage(stop: true);
            changeMicState(true);
            debugPrint('drag tamamlandi');
          },
          child: Container(
            height: size.height * 0.07,
            width: size.width * 0.13,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: messageColor,
            ),
            child: Icon(
              ref.watch(showMicProvider)
                  ? Icons.mic
                  : flutterSoundRecorder!.isRecording
                      ? Icons.close
                      : Icons.send,
              size: 25,
            ),
          ),
        ),
      ],
    );
  }

  TextField buildTextField(Size size) {
    return TextField(
      focusNode: focusNode,
      inputFormatters: const [],
      controller: controller,
      onChanged: (value) {
        if (value.contains('.gif')) {
          debugPrint('gif secildi');
        }
        controller.value = TextEditingValue(
            text: value,
            selection: TextSelection.collapsed(
                offset: controller.selection.baseOffset));
        if (value.isEmpty) {
          changeMicState(true);
        } else {
          changeMicState(false);
        }
      },
      style: const TextStyle(color: Colors.white, fontSize: 19),
      decoration: buildInputDecoration(size),
    );
  }

  InputDecoration buildInputDecoration(Size size) {
    return InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(200),
        ),
        contentPadding: const EdgeInsets.only(top: 20),
        hintText: 'Type a message',
        hintStyle: const TextStyle(
            color: Colors.white, overflow: TextOverflow.ellipsis, fontSize: 16),
        filled: true,
        prefixIcon: IconButton(
          icon: const Icon(Icons.emoji_emotions_rounded),
          onPressed: () {
            setState(() {
              showEmoji = !showEmoji;
            });
          },
        ),
        suffixIcon: SizedBox(
          width: size.width * 0.3,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                  onPressed: selectVideo,
                  icon: Transform.rotate(
                    angle: -45 * 3.14 / 180,
                    child: const Icon(
                      Icons.attach_file,
                    ),
                  )),
              IconButton(
                  onPressed: selectImage,
                  icon: const Icon(
                    Icons.photo_camera,
                  )),
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  const SizedBox(
                    height: 5,
                  ),
                  flutterSoundRecorder!.isRecording
                      ? SizedBox(
                          child: StreamBuilder<RecordingDisposition>(
                            stream: flutterSoundRecorder!.onProgress,
                            builder: (context, snapshot) {
                              final duration = snapshot.hasData
                                  ? snapshot.data!.duration
                                  : Duration.zero;

                              final twoDigitsMinutes =
                                  twoDigits(duration.inMinutes.remainder(60));
                              final twoDigitSeconds =
                                  twoDigits(duration.inSeconds.remainder(60));

                              return Row(
                                children: [
                                  const MicIcon(),
                                  Text('$twoDigitsMinutes:$twoDigitSeconds'),
                                ],
                              );
                            },
                          ),
                        )
                      : buildTextField(size),
                ],
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            buildMicButton(size)
          ],
        ),
        showEmoji
            ? SizedBox(
                height: 310.h,
                child: EmojiPicker(
                  onEmojiSelected: (category, emoji) {
                    setState(() {
                      controller.text = controller.text + emoji.emoji;
                      if (ref.read(showMicProvider)) {
                        changeMicState(false);
                      }
                    });
                  },
                ),
              )
            : const SizedBox()
      ],
    );
  }
}
