import 'package:flutter/material.dart';
import 'package:whatsapp_clone/core/utils/helpers.dart';

class SearchInput extends StatefulWidget {
  const SearchInput({
    super.key,
    required this.width,
  });

  final double width;

  @override
  State<SearchInput> createState() => _SearchInputState();
}

class _SearchInputState extends State<SearchInput> {
  bool back = false;
  late TextEditingController controller;
  final FocusNode focus = FocusNode();

  @override
  void initState() {
    controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    focus.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width * 0.8,
      child: TextField(
        focusNode: focus,
        controller: controller,
        onTap: () {
          setState(() {
            back = true;
          });
        },
        onTapOutside: (event) {
          setState(() {
            back = false;
            makeUnfocus(focus);
          });
        },
        decoration: InputDecoration(
            prefixIcon: back
                ? buildPrefixIcon(() {
                    back = false;
                    makeUnfocus(focus);
                  }, Icons.arrow_back_ios)
                : buildPrefixIcon(() => null, Icons.search)),
      ),
    );
  }

  InkWell buildPrefixIcon(Function() onTap, IconData icon) {
    return InkWell(
      onTap: () {
        setState(() {
          onTap();
        });
      },
      child: Icon(icon),
    );
  }
}
