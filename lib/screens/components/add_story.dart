import 'package:flutter/material.dart';
import 'package:whatsapp_clone/common/utils/colors.dart';
import 'package:whatsapp_clone/common/utils/helpers.dart';

class AddStoryButton extends StatelessWidget {
  const AddStoryButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        InkWell(
          onTap: () {
            
          },
          child: const Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: CircleAvatar(
              backgroundColor: backgroundColor,
              child: Icon(Icons.edit),
            ),
          ),
        ),
        FloatingActionButton(
            onPressed: () {
              selectImageForStatus(context);
            },
            child: const Icon(Icons.photo_camera, color: Colors.white)),
      ],
    );
  }
}
