// import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';
import 'package:whatsapp_clone/common/widgets/loading_screen.dart';

class VideoPlayerWidget extends ConsumerStatefulWidget {
  const VideoPlayerWidget({required this.videoUrl, super.key});
  final String videoUrl;

  @override
  ConsumerState<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends ConsumerState<VideoPlayerWidget> {
  // late CachedVideoPlayerController cachedVideoPlayerController;
  late VideoPlayerController videoPlayerController;
  bool videoPlayed = false;
  double opacity = 1;

  @override
  void initState() {
    // cachedVideoPlayerController =
    //     CachedVideoPlayerController.network(widget.videoUrl)
    //       ..initialize().then((value) {
    //         videoPlayerController.setVolume(1);
    //         setState(() {});
    //       });
    videoPlayerController = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((value) {
        videoPlayerController.setVolume(1);
        setState(() {});
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: videoPlayerController.value.isInitialized
          ? GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/flick-video-player',
                    arguments: videoPlayerController);
              },
              child: Stack(
                children: [
                  VideoPlayer(videoPlayerController),
                  // CachedVideoPlayer(cachedVideoPlayerController),
                  Align(
                      alignment: Alignment.center,
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 300),
                        opacity: opacity,
                        child: IconButton(
                            onPressed: () {
                              if (videoPlayed) {
                                videoPlayerController.pause();
                                opacity = 1;
                              } else {
                                videoPlayerController.play();
                                opacity = 0;
                              }

                              videoPlayed = !videoPlayed;
                              setState(() {});
                            },
                            icon: Icon(
                                videoPlayed ? Icons.pause : Icons.play_circle)),
                      ))
                ],
              ),
            )
          : const LoadingScreen(),
    );
  }
}
