import 'dart:async';

import 'package:audioplayers/audioplayers.dart';

class AudioService {
  AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  final String url;

  final StreamController<bool> _isPlayingController = StreamController<bool>();
  final StreamController<Duration> _durationController =
      StreamController<Duration>();
  final StreamController<Duration> _positionController =
      StreamController<Duration>();

  AudioService({required this.url}) {
    audioPlayer.onPlayerStateChanged.listen((state) {
      isPlaying = state == PlayerState.playing;
      _isPlayingController.add(isPlaying);
    });

    audioPlayer.onSeekComplete.listen((event) {});

    audioPlayer.onDurationChanged.listen((newDuration) {
      duration = newDuration;
      _durationController.add(duration);
    });

    audioPlayer.onPositionChanged.listen((newPosition) {
      position = newPosition;
      _positionController.add(position);
    });
  }

  Future<Duration> setDuration() async {
    await audioPlayer.setSourceUrl(url);
    var currentDuration = await audioPlayer.getDuration();
    return currentDuration!;
  }

  Future<void> play() async {
    await audioPlayer.play(UrlSource(url));
  }

  Future<void> pause() async {
    await audioPlayer.pause();
  }

  Future<void> seek(Duration position) async {
    await audioPlayer.seek(position);
  }

  Future<void> setSourceUrl(String url) async {
    await audioPlayer.setSourceUrl(url);
  }

  Stream<bool> get isPlayingStream => _isPlayingController.stream;

  Stream<Duration> get durationStream => _durationController.stream;

  Stream<Duration> get positionStream => _positionController.stream;

  void dispose() {
    audioPlayer.dispose();
    _isPlayingController.close();
    _durationController.close();
    _positionController.close();
  }
}
