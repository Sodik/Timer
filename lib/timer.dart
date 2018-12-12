import 'dart:async';
import 'formaters.dart';
import 'package:flutter/material.dart';

enum TimerStatus {
  idle,
  active,
  finished,
  paused,
  stopped,
}

class TimerClass {
  final Duration duration;
  final ValueChanged<String> onTick;
  final Function onFinish;
  final Function onStart;
  final Function onPause;
  TimerStatus _status = TimerStatus.idle;
  int _spentTime = 0;
  int _endTime;
  int _startTime;
  Timer _timer;

  TimerClass({
    this.duration,
    this.onTick,
    this.onFinish,
    this.onStart,
    this.onPause,
  });

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
    onStart();
    _status = TimerStatus.active;
    _startTime = new DateTime.now().millisecondsSinceEpoch;
    _endTime = _startTime + duration.inMilliseconds - _spentTime;
    _timer = new Timer.periodic(new Duration(seconds: 1), _onTick);

    _onTick(_timer);
  }

  void pause() {
    onPause();
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
    if (_timer != null) {
      _timer.cancel();
    }
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