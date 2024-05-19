import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';

class MyState extends ChangeNotifier {
  MyState();
  bool? isPlaying = false;
  AudioPlayer? player;
  void isPlayingAudio(bool? state) {
    isPlaying = state;
    notifyListeners();
  }

  void AudioData(AudioPlayer player) {
    this.player = player;
    notifyListeners();
  }
}
