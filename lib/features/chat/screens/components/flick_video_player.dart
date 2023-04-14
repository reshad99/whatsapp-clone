import 'package:flick_video_player/flick_video_player.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';

class FlickVideoPlayerWidget extends StatefulWidget {
  const FlickVideoPlayerWidget(
      {required this.videoPlayerController, super.key});
  final VideoPlayerController videoPlayerController;

  @override
  State<FlickVideoPlayerWidget> createState() => FlickVideoPlayerWidgetState();
}

class FlickVideoPlayerWidgetState extends State<FlickVideoPlayerWidget> {
  late FlickManager flickManager;

  @override
  Widget build(BuildContext context) {
    flickManager =
        FlickManager(videoPlayerController: widget.videoPlayerController);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: FlickVideoPlayer(
        flickManager: flickManager,
        flickVideoWithControls: const FlickVideoWithControls(
          closedCaptionTextStyle: TextStyle(fontSize: 8),
          controls: FlickPortraitControls(),
          videoFit: BoxFit.fitWidth,
        ),
        flickVideoWithControlsFullscreen: const FlickVideoWithControls(
          controls: FlickLandscapeControls(),
        ),
      ),
    );
  }
}
