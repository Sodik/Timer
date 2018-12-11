import 'package:flutter/material.dart';
import '../widgets/start_pause_button.dart';
import '../formaters.dart';
import '../player.dart';
import '../timer.dart';

class TimerPageState extends State<TimerPage> {
  TimerClass _timer;
  String _time = "";
  bool _isRinging = false;
  final _tickPlayer = new Player(
    file: 'tick.mp3',
  );
  final _alarmPlayer = new Player(
    file: 'alarm.mp3',
    duration: 3,
  );

  void initState() {
    super.initState();

    _timer = new TimerClass(
      duration: widget.duration,
      onStart: _onStart,
      onFinish: _onFinish,
      onPause: _onPause,
      onTick: (time) => setState(() {
        _time = time;
      }),
    );
    _timer.start();
  }

  void deactivate() {
    super.deactivate();

    _tickPlayer.stop();
    _alarmPlayer.stop();
    if (_timer != null) {
      _timer.stop();
    }
  }

  void _onStart() {
    _alarmPlayer.stop();
    _tickPlayer.play();
  }

  void _onPause() {
    _tickPlayer.stop();
  }

  void _onFinish() async {
    _tickPlayer.stop();
    setState(() {
      _isRinging = true;
    });
    await _alarmPlayer.play();
    setState(() {
      _isRinging = false;
    });
  }

  void _onTurnRingOff() {
    _alarmPlayer.stop();
    setState(() {
      _isRinging = false;
    });
  }

  void _onStartPause(bool shouldStart) {
    if (shouldStart) {
      _timer.resume();
    } else {
      _timer.pause();
      setState(() {});
    }
  }

  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Text(
                formatTime(widget.duration.inMilliseconds),
                style: new TextStyle(
                  color: Colors.grey,
                ),
              ),
              new Text(
                _time == null ? "" : _time,
                style: new TextStyle(
                  fontSize: 60.0,
                ),
              ),
            ],
          ),
        ],
        ),
        bottomNavigationBar: new Container(
          padding: EdgeInsets.only(bottom: 20),
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new IconButton(
                icon: new Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
              new StartPauseButton(
                isDisabled: false,
                isActive: _timer.isActive,
                onClick: _onStartPause,
              ),
              new IconButton(
                icon: new Icon(Icons.cancel),
                onPressed: _isRinging ? _onTurnRingOff : null,
              ),
            ],
          ),
        )
    );
  }
}

class TimerPage extends StatefulWidget {
  final Duration duration;

  TimerPage({ Key key, this.duration }): super(key: key);

  TimerPageState createState() => new TimerPageState();
}
