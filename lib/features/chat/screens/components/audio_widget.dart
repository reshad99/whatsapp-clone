import 'package:flutter/material.dart';
import 'package:whatsapp_clone/common/utils/helpers.dart';
import 'package:whatsapp_clone/services/audio_player_service.dart';

class AudioWidget extends StatefulWidget {
  const AudioWidget({
    Key? key,
    required this.message,
  }) : super(key: key);
  final String message;

  @override
  State<AudioWidget> createState() => _AudioWidgetState();
}

class _AudioWidgetState extends State<AudioWidget> {
  late AudioService audioService;
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void initState() {
    super.initState();
    audioService = AudioService(url: widget.message);
  }

  @override
  void dispose() {
    super.dispose();
    audioService.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return StreamBuilder<bool>(
        stream: audioService.isPlayingStream,
        builder: (context, snapshot) {
          isPlaying = snapshot.data ?? false;
          return FutureBuilder<Duration>(
            future: audioService.setDuration(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                duration = snapshot.data!;
              }
              return buildMessageCard(size);
            },
          );
        });
  }

  ConstrainedBox buildMessageCard(Size size) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: size.width * 0.60),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildPlayButton(),
          StreamBuilder<Duration>(
              stream: audioService.positionStream,
              builder: (context, snapshot) {
                position = snapshot.data ?? Duration.zero;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [buildSlider(), buildDuration()],
                );
              })
        ],
      ),
    );
  }

  Text buildDuration() {
    return Text(isPlaying
        ? '${twoDigits(position.inMinutes)}:${twoDigits(position.inSeconds.remainder(60))}'
        : '${twoDigits(duration.inMinutes)}:${twoDigits(duration.inSeconds.remainder(60))}');
  }

  Slider buildSlider() {
    return Slider(
      min: 0,
      value: position.inSeconds.toDouble(),
      max: duration.inSeconds.toDouble(),
      onChanged: (value) async {
        final position = Duration(seconds: value.toInt());
        await audioService.seek(position);
      },
    );
  }

  IconButton buildPlayButton() {
    return IconButton(
        onPressed: () async {
          if (isPlaying) {
            await audioService.pause();
          } else {
            await audioService.play();
          }
        },
        icon: Icon(isPlaying ? Icons.pause : Icons.play_circle));
  }
}
