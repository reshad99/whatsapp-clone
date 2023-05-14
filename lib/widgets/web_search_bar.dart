import 'package:flutter/material.dart';
import 'package:whatsapp_clone/core/utils/colors.dart';
import 'package:whatsapp_clone/widgets/search_input.dart';

class WebSearchBar extends StatelessWidget {
  const WebSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double width = size.width * 0.25;
    return Container(
      width: width,
      height: size.height * 0.077,
      padding: const EdgeInsets.all(15),
      decoration: const BoxDecoration(color: webAppBarColor),
      child: Row(
        children: [
          SearchInput(width: width),
          Expanded(
            child: Material(
              child: InkWell(
                child: IconButton(
                    splashColor: Colors.white.withOpacity(0.5),
                    onPressed: () {},
                    icon: const Icon(Icons.filter_list)),
              ),
            ),
          )
        ],
      ),
    );
  }
}
