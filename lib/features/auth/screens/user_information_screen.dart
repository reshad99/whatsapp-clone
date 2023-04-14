import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/common/enums/file_type.dart';
import 'package:whatsapp_clone/common/enums/message_enum.dart';
import 'package:whatsapp_clone/common/utils/helpers.dart';
import 'package:whatsapp_clone/features/auth/controller/auth_controller.dart';

class UserInformationScreen extends ConsumerStatefulWidget {
  const UserInformationScreen({super.key});

  @override
  ConsumerState<UserInformationScreen> createState() =>
      _UserInformationScreenState();
}

class _UserInformationScreenState extends ConsumerState<UserInformationScreen> {
  late TextEditingController usernameController;
  File? image;

  @override
  void initState() {
    usernameController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    usernameController.dispose();
  }

  void selectImage() async {
    image = await pickFileFromGallery(context, FileType.image);
    setState(() {});
  }

  void saveUserData() {
    String name = usernameController.text;
    if (name.isNotEmpty) {
      ref
          .read(authControllerProvider)
          .saveUserDataToFirebase(context, name, image);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Column(
          children: [
            Stack(
              children: [
                image == null
                    ? const CircleAvatar(
                        backgroundImage: AssetImage('assets/profile-icon.png'),
                        radius: 64,
                      )
                    : CircleAvatar(
                        backgroundImage: FileImage(image!),
                        radius: 64,
                      ),
                Positioned(
                    bottom: 0,
                    right: 0,
                    child: IconButton(
                      splashRadius: 1.0,
                      icon: const Icon(Icons.add_a_photo),
                      onPressed: () {
                        selectImage();
                      },
                    ))
              ],
            ),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  width: size.width * 0.85,
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Type your name',
                    ),
                    controller: usernameController,
                  ),
                ),
                IconButton(
                    onPressed: () {
                      saveUserData();
                    },
                    icon: const Icon(Icons.check))
              ],
            )
          ],
        ),
      )),
    );
  }
}
