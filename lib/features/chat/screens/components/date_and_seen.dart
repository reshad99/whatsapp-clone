import 'package:flutter/material.dart';

class DateAndSeen extends StatelessWidget {
  const DateAndSeen({
    super.key,
    required this.date,
    required this.isMe,
    required this.isSeen,
  });

  final String date;
  final bool isMe;
  final bool isSeen;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(date),
        const SizedBox(
          width: 5,
        ),
        if (isMe)
          Icon(Icons.done_all,
              color: isSeen ? Colors.blue : Colors.white, size: 20),
      ],
    );
  }
}
