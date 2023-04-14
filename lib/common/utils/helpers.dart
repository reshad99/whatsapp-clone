import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_list_view/flutter_list_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp_clone/common/enums/file_type.dart';
import 'package:whatsapp_clone/common/enums/message_enum.dart';
import 'package:whatsapp_clone/common/utils/info.dart';
import 'package:whatsapp_clone/common/widgets/loading_screen.dart';
import 'package:whatsapp_clone/features/chat/controller/chat_controller.dart';
import 'package:whatsapp_clone/features/chat/screens/components/audio_card.dart';
import 'package:whatsapp_clone/features/chat/screens/components/audio_widget.dart';
import 'package:whatsapp_clone/features/chat/screens/components/audio_widget_test.dart';
import 'package:whatsapp_clone/features/chat/screens/components/image_card.dart';
import 'package:whatsapp_clone/features/chat/screens/components/image_widget.dart';
import 'package:whatsapp_clone/features/chat/screens/components/text_card.dart';
import 'package:whatsapp_clone/features/chat/screens/components/video_card.dart';
import 'package:whatsapp_clone/features/chat/screens/components/video_player.dart';
import 'package:whatsapp_clone/screens/components/add_story.dart';
import 'package:whatsapp_clone/screens/mobile_screen_layout.dart';

void makeUnfocus(FocusNode focusNode) {
  focusNode.unfocus();
}

void showSnackbar(
    {required BuildContext context, required String content, Color? color}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(content),
    backgroundColor: color ?? Colors.white,
  ));
}

Future<File?> pickFileFromGallery(
    BuildContext context, FileType fileType) async {
  File? file;

  try {
    final pickedFile = fileType == FileType.image
        ? await ImagePicker().pickImage(source: ImageSource.gallery)
        : await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      file = File(pickedFile.path);
    }
  } catch (e) {
    showSnackbar(context: context, content: e.toString());
  }
  return file;
}

void buildLoader(BuildContext context) {
  showDialog(context: context, builder: (context) => const LoadingScreen());
}

String getDefaultProfilePhoto() {
  return 'assets/profile-icon.png';
}

ImageProvider getProfilePic(dynamic value) {
  return value != getDefaultProfilePhoto()
      ? NetworkImage(value)
      : AssetImage(value) as ImageProvider;
}

void permissions() async {
  await FlutterContacts.requestPermission();
}

Radius radius(double radius) {
  return Radius.circular(radius);
}

String timeDifference(String date) {
  DateTime messageTime = DateTime.parse(date);
  DateTime now = DateTime.now();

  // Today's date at midnight
  DateTime today = DateTime(now.year, now.month, now.day);

  // Difference between the message time and now
  Duration difference = now.difference(messageTime);
  if (difference.inHours < 1) {
    return DateFormat('HH:mm').format(messageTime);
  } else if (messageTime.isAfter(today)) {
    return DateFormat('HH:mm').format(messageTime);
  } else if (messageTime.isAfter(today.subtract(const Duration(days: 1)))) {
    return 'Yesterday, ${DateFormat('HH:mm').format(messageTime)}';
  } else {
    return DateFormat('yyyy/MM/dd HH:mm:ss').format(messageTime);
  }
}

String timeForMessage(String date) {
  DateTime messageTime = DateTime.parse(date);
  DateTime now = DateTime.now();

  // Today's date at midnight
  DateTime today = DateTime(now.year, now.month, now.day);

  // Difference between the message time and now
  Duration difference = now.difference(messageTime);
  if (difference.inHours < 1) {
    return DateFormat('HH:mm').format(messageTime);
  } else if (messageTime.isAfter(today)) {
    return DateFormat('HH:mm').format(messageTime);
  } else if (messageTime.isAfter(today.subtract(const Duration(days: 1)))) {
    return DateFormat('HH:mm').format(messageTime);
  } else {
    return DateFormat('HH:ss').format(messageTime);
  }
}

String formatDate(DateTime date) {
  DateFormat formatter = DateFormat("yyyy-MM-dd HH:mm:ss");
  return formatter.format(date);
}

void scrollToBottom(FlutterListViewController scrollController, int length) {
  SchedulerBinding.instance.addPostFrameCallback((_) {
    final position = scrollController.position;
    final maxScrollExtent = position.maxScrollExtent;
    final test = position.minScrollExtent;
    scrollController.sliverController
        .jumpToIndex(length - 1, offsetBasedOnBottom: true);
  });
}

dynamic getMessageFormat(MessageType messageType, String message) {
  switch (messageType) {
    case MessageType.text:
      return Text(
        message,
        style: const TextStyle(fontSize: messageFontSize),
      );
    case MessageType.audio:
      return AudioWidget(
        message: message,
      );
    case MessageType.video:
      return VideoPlayerWidget(videoUrl: message);
    case MessageType.gif:
      return Text(message);
    case MessageType.image:
      return ImageMessage(message: message);
    default:
  }
}

dynamic getMessageCard(MessageType messageType, String message, Size size,
    String date, bool isMe, bool isSeen) {
  switch (messageType) {
    case MessageType.text:
      return TextCard(
        size: size,
        messageType: messageType,
        message: message,
        date: date,
        isMe: isMe,
        isSeen: isSeen,
      );
    case MessageType.audio:
      return AudioCard(
        size: size,
        messageType: messageType,
        message: message,
        date: date,
        isMe: isMe,
        isSeen: isSeen,
      );
    case MessageType.video:
      return VideoCard(
        size: size,
        messageType: messageType,
        message: message,
        date: date,
        isMe: isMe,
        isSeen: isSeen,
      );
    case MessageType.gif:
      return Text(message);
    case MessageType.image:
      return ImageCard(
          size: size,
          messageType: messageType,
          message: message,
          date: date,
          isMe: isMe);
    default:
      return Text(message);
  }
}

String twoDigits(int n) {
  return n.toString().padLeft(2, '0');
}

void selectImageForStatus(BuildContext context) async {
  var image = await pickFileFromGallery(context, FileType.image);
  if (image != null) {
    Future.microtask(() =>
        Navigator.pushNamed(context, '/status-confirm', arguments: image));
  }
}

String getFileExtension(String filePath) {
  int dotIndex = filePath.lastIndexOf('.');
  return dotIndex != -1 ? filePath.substring(dotIndex + 1) : '';
}

bool isVideoFile(String filePath) {
  final extension = getFileExtension(filePath);
  return extension == 'mp4' || extension == 'avi' || extension == 'mov';
}

bool isImageFile(String filePath) {
  final extension = getFileExtension(filePath);
  return extension == 'jpg' ||
      extension == 'jpeg' ||
      extension == 'png' ||
      extension == 'gif';
}

Widget getFloatingButton(WidgetRef ref) {
  var index = ref.watch(tabIndexProvider);
  switch (index) {
    case 0:
      return const SelectContactButton();
    case 1:
      return const AddStoryButton();
    default:
      return const SelectContactButton();
  }
}

String generateChatId(String senderId, String receiverId) {
  var chatId = '${senderId}_$receiverId';
  return chatId;
}
