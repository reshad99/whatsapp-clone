import 'package:flutter/material.dart';
import 'package:whatsapp_clone/common/utils/colors.dart';

class WebProfileBar extends StatelessWidget {
  const WebProfileBar({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.all(15),
      width: size.width * 0.25,
      height: size.height * 0.077,
      decoration: const BoxDecoration(
          color: webAppBarColor,
          border: Border(right: BorderSide(color: dividerColor))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const CircleAvatar(
            backgroundImage: NetworkImage(
                "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png"),
            radius: 20,
          ),
          Row(
            children: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.comment)),
              IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))
            ],
          )
        ],
      ),
    );
  }
}
