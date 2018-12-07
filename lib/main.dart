import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

void main() => runApp(new App());

class TimerClass {
  final Duration duration;
  final ValueChanged<int> onTick;
  int _endTime;
  int _startTime;
  Timer _timer;

  TimerClass(Duration this.duration,  this.onTick) {}

  start() {
    print(duration);
    _startTime = new DateTime.now().millisecondsSinceEpoch;
    _endTime = _startTime +  duration.inMilliseconds;
    _timer = new Timer.periodic(new Duration(seconds: 1), _onTick);
  }

  stop() {
    print('Finished');
    _timer.cancel();
  }

  _onTick(Timer) {
    int currentTime = new DateTime.now().millisecondsSinceEpoch;

    this.onTick(timeRemaining);

    if (currentTime >= _endTime) {
      stop();
    }
  }

  int get timeRemaining {
    return _endTime - (_startTime + _timer.tick * Duration.millisecondsPerSecond);
  }

  /*String timeRemaining() {
    int time = endTime - (startTime + timer.tick * Duration.millisecondsPerSecond);
    int hours = (time / Duration.millisecondsPerHour).floor();
    int minutes = ((time - (hours * Duration.millisecondsPerHour)) / Duration.millisecondsPerMinute).floor();
    int seconds = ((time - (minutes * Duration.millisecondsPerMinute)) / Duration.millisecondsPerSecond).floor();

    return "${_formatNumber(hours)}:${_formatNumber(minutes)}:${_formatNumber(seconds)}";
  }

  _formatNumber(int number) {
    return number < 10 ? "0${number}" : number.toString();
  }*/
}

class _TimerWidgetState extends State<TimerWidget> {
  Duration duration;
  String time = '';
  TimerClass timer;

  _TimerWidgetState() {
    timer = new TimerClass(duration, (value) => setState(() => time = value.toString()));
  }

  Widget build(BuildContext context) {
    return new Container(
      child: new Text(time),
    );
  }
}

class TimerWidget extends StatefulWidget {
  Duration duration;

  TimerWidget(Duration this.duration);

  _TimerWidgetState createState() => new _TimerWidgetState();
}

class App extends StatelessWidget {
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Timer',
      home: new HomePage(),
    );
  }
}

class _HomePageState extends State<HomePage> {
  Duration _duration;
  Duration timer;

  setDuration(duration) {
    _duration = duration;
  }

  onStart() {
    TimerClass timer = new TimerClass(_duration, (int remainingTime) => print(remainingTime));

    timer.start();

    timer = timer;
  }

  renderTimer() {
    if(timer != null) {
      return new Container(
          child: new Column(
            children: <Widget>[
              new TimerWidget(timer)
            ],
          )
      );
    }

    return new Container();
  }

  Widget build(BuildContext context) {
    return new Scaffold(
        body: Container(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Container(
                  height: 140.0,
                  child: new CupertinoTimerPicker(onTimerDurationChanged: setDuration),
                ),
                new Container(
                  child: new IconButton(
                    onPressed: onStart,
                    icon: new Icon(Icons.play_arrow),
                  ),
                ),
                renderTimer(),
              ],
            )
        )
    );
  }
}

class HomePage extends StatefulWidget {
  _HomePageState createState() => new _HomePageState();
}