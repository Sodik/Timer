import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';

class Player {
  String file;
  int duration;
  AudioCache _cache;
  final AudioPlayer _player = new AudioPlayer();
  double _volume = 1.0;

  Player({ this.file, this.duration }) {
    _player.setVolume(_volume);
    _cache = new AudioCache(
      fixedPlayer: _player,
    );
    _cache.load(file);
  }

  Future<void> play() async {
    var withDuration = duration != null;

    _player.stop();
    await (withDuration ? _cache.play(file) : _cache.loop(file));

    if (withDuration) {
      return new Future.delayed(Duration(seconds: duration), stop);
    }
  }

  void stop() {
    _player.stop();
  }

  void soundOff() {
    _volume = 0;
    _player.setVolume(_volume);
  }

  void soundOn() {
    _volume = 1;
    _player.setVolume(_volume);
  }
}