// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whatsapp_clone/common/utils/colors.dart';
import 'package:whatsapp_clone/common/utils/helpers.dart';
import 'package:whatsapp_clone/features/status/controller/status_controller.dart';

class StatusConfirm extends ConsumerWidget {
  const StatusConfirm({
    Key? key,
    required this.file,
  }) : super(key: key);
  final File file;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusTextController = TextEditingController();
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            SizedBox(
              height: size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FadeInImage(
                    width: size.width,
                    placeholder: AssetImage(getDefaultProfilePhoto()),
                    image: FileImage(file),
                    placeholderFit: BoxFit.cover,
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 100,
              right: 0,
              left: 0,
              child: TextField(
                controller: statusTextController,
                decoration: InputDecoration(

                  hintText: 'Add a caption',
                  filled: true,
                  fillColor: appBarColor,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(200),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          foregroundColor: appBarColor,
          backgroundColor: messageColor,
          onPressed: () {
            ref
                .read(statusControllerProvider)
                .saveStory(context, file, statusTextController.text);
          },
          child: const Icon(
            Icons.send,
            color: Colors.white,
          )),
    );
  }
}
