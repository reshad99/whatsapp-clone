import 'package:flutter/material.dart';

class MicIcon extends StatefulWidget {
  const MicIcon({super.key});

  @override
  State<MicIcon> createState() => _MicIconState();
}

class _MicIconState extends State<MicIcon> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    final animation =
        Tween(begin: 0.1, end: 1.0).animate(_animationController);
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Icon(
          Icons.mic,
          size: 50,
          color:
              _animationController.value > 0.5 ? Colors.red.withOpacity(animation.value) : Colors.transparent,
        );
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
