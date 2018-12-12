import 'package:flutter/material.dart';

import '../widgets/start_pause_button.dart';
import '../formaters.dart';
import '../player.dart';
import '../timer.dart';

class _SaveDialogState extends State<_SaveDialog> {
  String _timerName = '';
  final inputController = new TextEditingController();

  void initState() {
    super.initState();

    inputController.addListener(() {
      setState(() {
        _timerName = inputController.text;
      });
    });
  }

  void dispose() {
    super.dispose();

    inputController.dispose();
  }

  Widget build(BuildContext context) {
    return new SimpleDialog(
        children: <Widget>[
          new Form(
              child: new Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: new Container(
                    height: 140,
                    child: new Column(
                      children: <Widget>[
                        new TextField(
                          controller: inputController,
                          decoration: InputDecoration(
                              labelText: 'Enter your timer name'
                          ),
                        ),
                        new Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: new Row(
                              children: <Widget>[
                                new FlatButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: new Text('Cancel'),
                                ),
                                new RaisedButton(
                                  onPressed: _timerName.length > 0 ? () {
                                    widget.onSave(_timerName, widget.duration.toString());
                                    Navigator.pop(context);
                                  } : null,
                                  child: Text('Save'),
                                ),
                              ],
                            )
                        ),
                      ],
                    ),
                  )
              )
          ),
        ],
      );
  }
}

class _SaveDialog extends StatefulWidget {
  final Duration duration;
  final Function onSave;

  _SaveDialog({
    Key key,
    @required this.duration,
    @required this.onSave,
  }): super(key: key);

  _SaveDialogState createState() => new _SaveDialogState();
}

class TimerPageState extends State<TimerPage> {
  Dialog dialog;
  TimerClass _timer;
  String _time = "";
  bool _isRinging = false;
  bool _isUnmounted = false;
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

  void dispose() {
    super.dispose();

    _isUnmounted = true;

    _tickPlayer.stop();
    _alarmPlayer.stop();
    _timer.stop();

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
   if (!_isUnmounted) {
     setState(() {
       _isRinging = false;
     });
   }
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

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return new _SaveDialog(
          onSave: widget.onSave,
          duration: widget.duration,
        );
      },
    );
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
              new FlatButton(
                child: new Text('Save Timer'),
                onPressed: _showDialog,
              )
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
                icon: new Icon(Icons.cancel),
                onPressed: () => Navigator.pop(context),
              ),
              new StartPauseButton(
                isDisabled: false,
                isActive: _timer.isActive,
                onClick: _onStartPause,
              ),
              new IconButton(
                icon: new Icon(Icons.notifications_off),
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
  final Function onSave;

  TimerPage({
    Key key,
    @required this.duration,
    @required this.onSave,
  }): super(key: key);

  TimerPageState createState() => new TimerPageState();
}
