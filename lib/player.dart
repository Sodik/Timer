import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';

class Player {
  String file;
  int duration;
  AudioCache _cache;
  AudioPlayer _player;
  double _volume = 1.0;

  Player({ this.file, this.duration }) {
    _cache = new AudioCache();
    _cache.load(file);
  }

  play() async {
    var withDuration = duration != null;

    if (_player != null) {
      _player.stop();
    }

    _player = await (withDuration ? _cache.play(file) : _cache.loop(file));
    _player.setVolume(_volume);

    if (withDuration) {
      return new Future.delayed(Duration(seconds: 3), stop);
    }
  }

  stop() {
    if (_player == null) {
      return;
    }

    _player.stop();
    _player = null;
  }

  off() {
    _volume = 0;

    if (_player != null) {
      _player.setVolume(_volume);
    }
  }

  on() {
    _volume = 1;

    if (_player != null) {
      _player.setVolume(_volume);
    }
  }
}