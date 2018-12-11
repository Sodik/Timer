import 'package:flutter/material.dart';
import '../widgets/start_pause_button.dart';
import '../widgets/restore_button.dart';
import '../formaters.dart';
import '../timer.dart';

class TimerPageState extends State<TimerPage> {
  TimerInterface _timer;
  String _time = "";

  void initState() {
    super.initState();

    _timer = new TimerWithSound(
        widget.duration,
        (value) => setState(() => _time = value),
        _onFinish);
    _timer.start();
  }

  void deactivate() {
    super.deactivate();

    if (_timer != null) {
      _timer.stop();
    }
  }

  void _onReset() {
    _timer.reset();
  }

  void _onFinish() {
    widget.onFinish();
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
        bottomNavigationBar: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new RestoreButton(
              isActive: !_timer.isFinished,
              onClick: _onReset,
            ),
            new StartPauseButton(
              isDisabled: _timer.isFinished,
              isActive: _timer.isActive,
              onClick: _onStartPause,
            ),
            new IconButton(icon: new Icon(Icons.cancel), onPressed: _timer.isFinished ? () => Navigator.pop(context) : null)
          ],
        ),
    );
  }
}

class TimerPage extends StatefulWidget {
  final Duration duration;
  final Function onFinish;

  TimerPage({ Key key, this.duration, this.onFinish }): super(key: key);

  TimerPageState createState() => new TimerPageState();
}
