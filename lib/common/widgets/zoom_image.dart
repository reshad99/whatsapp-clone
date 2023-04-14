import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_clone/common/utils/info.dart';

class ZoomImage extends StatefulWidget {
  const ZoomImage({required this.imageUrl, super.key});
  final String imageUrl;

  @override
  State<ZoomImage> createState() => _ZoomImageState();
}

class _ZoomImageState extends State<ZoomImage>
    with SingleTickerProviderStateMixin {
  late TransformationController controller;
  TapDownDetails? tapDownDetails;
  ScaleEndDetails? scaleEndDetails;

  late AnimationController animationController;
  Animation<Matrix4>? animation;

  @override
  void initState() {
    super.initState();
    controller = TransformationController();
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300))
      ..addListener(() {
        controller.value = animation!.value;
      });
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
    animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTapDown: (details) => tapDownDetails = details,
      onDoubleTap: () {
        debugPrint('double tap success');
        final position = tapDownDetails!.localPosition;
        const double scale = 4;
        final x = -position.dx * (scale - 1);
        final y = -position.dy * (scale - 1);
        final zoomed = Matrix4.identity()
          ..translate(x, y)
          ..scale(scale);
        final end = controller.value.isIdentity() ? zoomed : Matrix4.identity();

        animation = Matrix4Tween(begin: controller.value, end: end).animate(
            CurvedAnimation(
                curve: Curves.easeOut, parent: animationController));
        animationController.forward(from: 0);
      },
      onScaleStart: (details) {
        debugPrint('scale succcess');
      },
      onScaleEnd: (details) {
        debugPrint('scale succcess');
      },
      onScaleUpdate: (details) {
        debugPrint('onscaleUpdate ssuccess');
        final newScale = controller.value.storage[0] * (details.scale);
        if (newScale < 1) {
          controller.value = Matrix4.identity();
          return;
        }
        controller.value = Matrix4.identity()
          ..scale(newScale)
          ..translate(details.focalPoint.dx, details.focalPoint.dy);
      },
      child: InteractiveViewer(
        transformationController: controller,
        maxScale: maxZoomScale,
        minScale: minZoomScale,
        clipBehavior: Clip.none,
        panEnabled: true,
        onInteractionEnd: (details) {
          debugPrint('interaction end success');
          scaleEndDetails = details;
        },
        scaleEnabled: true,
        child: Hero(
          tag: widget.imageUrl,
          child: CachedNetworkImage(
            imageUrl: widget.imageUrl,
            fit: BoxFit.fitHeight,
          ),
        ),
      ),
    );
  }
}
