import 'dart:async';
import 'player.dart';
import 'formaters.dart';
import 'package:flutter/material.dart';

class TimerInterface {
  final Duration duration;
  final ValueChanged<String> onTick;
  final Function onFinish;

  TimerInterface(this.duration,  this.onTick, this.onFinish);

  get isActive {}
  get isFinished {}

  void start() {}
  void pause() {}
  void resume() {}
  void stop() {}
  void reset() {}
}

enum TimerStatus {
  idle,
  active,
  finished,
  paused,
  stopped,
}

class TimerClass implements TimerInterface {
  final Duration duration;
  final ValueChanged<String> onTick;
  final Function onFinish;
  TimerStatus _status = TimerStatus.idle;
  int _spentTime = 0;
  int _endTime;
  int _startTime;
  Timer _timer;

  TimerClass(Duration this.duration,  this.onTick, this.onFinish);

  bool get isActive {
    return
      _timer != null &&
      _timer.isActive &&
      _status != TimerStatus.finished;
  }

  bool get isFinished {
    return _status == TimerStatus.finished;
  }

  void start() {
    _status = TimerStatus.active;
    _startTime = new DateTime.now().millisecondsSinceEpoch;
    _endTime = _startTime + duration.inMilliseconds - _spentTime;
    _timer = new Timer.periodic(new Duration(seconds: 1), _onTick);

    _onTick(_timer);
  }

  void pause() {
    _status = TimerStatus.paused;
    _spentTime += _timer.tick * Duration.millisecondsPerSecond;
    _timer.cancel();
  }

  void reset() {
    stop();
    onTick(formatTime(_endTime - _startTime));
  }

  void resume() {
    start();
  }

  void stop() {
    if (!isFinished) {
      _status = TimerStatus.stopped;
    }

    _spentTime = 0;
    _timer.cancel();
  }

  void _onTick(Timer) {
    int currentTime = new DateTime.now().millisecondsSinceEpoch;

    onTick(timeRemaining);

    if (currentTime >= _endTime) {
      _status = TimerStatus.finished;
      onFinish();
      stop();
    }
  }

  String get timeRemaining{
    int time = _endTime - (_startTime + _timer.tick * Duration.millisecondsPerSecond);

    return formatTime(time);
  }
}

class TimerWithSound implements TimerInterface {
  final Duration duration;
  final ValueChanged<String> onTick;
  final Function onFinish;
  TimerClass _timer;
  Player _tickPlayer;
  Player _alarmPlayer;


  TimerWithSound(Duration this.duration,  this.onTick, this.onFinish) {
    _timer = new TimerClass(duration, onTick, _onFinish);
    _tickPlayer = new Player(
      file: 'tick.mp3',
    );
    _alarmPlayer = new Player(
      file: 'alarm.mp3',
      duration: 3,
    );
  }

  get isActive {
    return _timer.isActive;
  }

  get isFinished {
    return _timer.isFinished;
  }

  void _onFinish() async {
    _tickPlayer.stop();
    _timer.stop();
    await _alarmPlayer.play();
    onFinish();
  }

  void start() {
    _timer.start();
    _tickPlayer.play();
  }

  void pause() {
    _timer.pause();
    _tickPlayer.stop();
  }

  void resume() {
    _timer.resume();
    _tickPlayer.play();
  }

  void stop() {
    _timer.stop();
    _tickPlayer.stop();
    _alarmPlayer.stop();
  }

  void reset() {
    _timer.reset();
    _tickPlayer.stop();
  }
}