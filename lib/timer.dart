import 'dart:async';
import 'package:flutter/material.dart';

class TimerClass {
  final Duration duration;
  final ValueChanged<String> onTick;
  final onFinish;
  int _spentTime = 0;
  int _endTime;
  int _startTime;
  Timer _timer;

  TimerClass(Duration this.duration,  this.onTick, this.onFinish) {}

  bool get isActive{
    return _timer != null && _timer.isActive;
  }

  start() {
    _startTime = new DateTime.now().millisecondsSinceEpoch;
    _endTime = _startTime + duration.inMilliseconds - _spentTime;
    _timer = new Timer.periodic(new Duration(seconds: 1), _onTick);

    _onTick(_timer);
  }

  pause() {
    _spentTime += _timer.tick * Duration.millisecondsPerSecond;
    print(_timer.tick);
    stop();
  }

  resume() {
    start();
  }

  stop() {
    _timer.cancel();
  }

  _onTick(Timer) {
    int currentTime = new DateTime.now().millisecondsSinceEpoch;

    onTick(timeRemaining);

    if (currentTime >= _endTime) {
      onFinish();
      stop();
    }
  }

  String get timeRemaining{
    int time = _endTime - (_startTime + _timer.tick * Duration.millisecondsPerSecond);
    int hours = (time / Duration.millisecondsPerHour).floor();
    int minutes = ((time - (hours * Duration.millisecondsPerHour)) / Duration.millisecondsPerMinute).floor();
    int seconds = ((time - (minutes * Duration.millisecondsPerMinute)) / Duration.millisecondsPerSecond).floor();

    return "${_formatNumber(hours)}:${_formatNumber(minutes)}:${_formatNumber(seconds)}";
  }

  _formatNumber(int number) {
    return number < 10 ? "0${number}" : number.toString();
  }
}