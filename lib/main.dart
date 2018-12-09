import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'widgets/control_panel.dart';
import 'timer.dart';
import 'player.dart';

void main() => runApp(new App());

final alarmPlayer = new Player(
  file: 'alarm.mp3',
  duration: 3,
);

final tickPlayer = new Player(
  file: 'tick.mp3',
);

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
  TimerClass _timer;
  String _time;
  bool _soundOff = false;

  _setDuration(duration) {
    if (_timer != null) {
      _timer.stop();
      _timer = null;
    }

    setState(() {
      _duration = duration;
    });
  }

  _onStart() {
    tickPlayer.play();

    if (_timer != null) {
      _timer.resume();
      return;
    }

    _timer = new TimerClass(
        _duration,
            (tick) => setState(() => _time = tick),
        _onFinish,
    );
    _timer.start();
  }

  _onReset() {
    if (_timer != null) {
      tickPlayer.stop();
      _timer.stop();
      setState(() {
        _timer = null;
        _time = null;
      });
    }
  }

  _onPause() {
    tickPlayer.stop();
    _timer.pause();
    setState(() {});
  }

  _onFinish() async {
    tickPlayer.stop();
    await alarmPlayer.play();
    setState(() {
      _timer = null;
      _time = null;
    });
  }

  _onVolume() {
    if (_soundOff) {
      tickPlayer.off();
      setState(() {
        _soundOff = false;
      });
    } else {
      tickPlayer.on();
      setState(() {
        _soundOff = true;
      });
    }
  }

  Widget build(BuildContext context) {
    return new Scaffold(
        body: Container(
            child: new Column(
              children: <Widget>[
                new Container(
                  padding: EdgeInsets.only(top: 20.0),
                  alignment: Alignment(0.95, 0),
                  child: new IconButton(
                    icon: new Icon(
                        _soundOff ? Icons.volume_mute : Icons.volume_off
                    ),
                    onPressed: _onVolume,
                  ),
                ),
                new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Container(
                      height: 140.0,
                      child: new CupertinoTimerPicker(onTimerDurationChanged: _setDuration),
                    ),
                    new Container(
                      padding: EdgeInsets.only(bottom: 10.00, top: 30.00),
                      child: new Text(
                        _time == null ? "" : _time,
                        style: new TextStyle(
                          fontSize: 28.0,
                        ),
                      ),
                    ),
                    new ControlPanel(
                      onStart: _onStart,
                      onPause: _onPause,
                      onReset: _onReset,
                      isActive: _timer != null && _timer.isActive,
                      isDisabled: _duration == null || _duration.inMilliseconds == 0,
                    ),
                  ],
                )
              ],
            )
        )
    );
  }
}

class HomePage extends StatefulWidget {
  _HomePageState createState() => new _HomePageState();
}