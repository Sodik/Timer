import 'package:flutter/material.dart';
import 'package:vibrate/vibrate.dart';

import '../widgets/start_pause_button.dart';
import '../managers/setttings.dart';
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
                          autofocus: true,
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
                                  child: new Text('Save'),
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
  String _time = '';
  final bool tickSound;
  final bool alarmSound;
  bool _isRinging = false;
  final _tickPlayer = new Player(
    file: 'tick.mp3',
  );
  final _alarmPlayer = new Player(
    file: 'alarm.mp3',
    duration: 3,
  );

  TimerPageState({
    Key key,
    this.tickSound,
    this.alarmSound,
  });

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
    if (!widget.isSavedTimer) {
      _timer.start();
    } else {
      _time = formatTime(widget.duration.inMilliseconds);
    }
  }

  void _playTick() {
    if (tickSound) {
      _tickPlayer.play();
    }
  }

  void _stopTick() {
    if (tickSound) {
      _tickPlayer.stop();
    }
  }

  Future _playAlarm() async {
    if (alarmSound) {
      setState(() {
        _isRinging = true;
      });

      return _alarmPlayer.play().then((void res) {
        if (mounted) {
          setState(() {
            _isRinging = false;
          });
        }
      });
    }

    final bool canVibrate = await Vibrate.canVibrate;

    if (canVibrate) {
      return Vibrate.vibrate();
    }
  }

  void _stopAlarm([bool withoutUpdatingState]) {
    if (alarmSound) {
      _alarmPlayer.stop();

      if (withoutUpdatingState != null && !withoutUpdatingState) {
        setState(() {
          _isRinging = false;
        });
      }
    }
  }

  void dispose() {
    super.dispose();

    _timer.stop();
    _stopTick();
    _stopAlarm(true);

  }

  void _onStart() {
    _stopAlarm();
    _playTick();
  }

  void _onPause() {
    _stopTick();
  }

  void _onFinish() {
    _stopTick();
    _playAlarm();
  }

  void _onTurnRingOff() {
    _stopAlarm();
  }

  void _onStartPause(bool shouldStart) {
    if (shouldStart) {
      _timer.resume();
    } else {
      _timer.pause();
      setState(() {});
    }
  }


  List<Widget> _renderContent() {
    var items = <Widget>[
      new Text(
        formatTime(widget.duration.inMilliseconds),
        style: new TextStyle(
          color: Colors.grey,
        ),
      ),
      new Text(
        _time,
        style: new TextStyle(
          fontSize: 60.0,
        ),
      ),
    ];

    if (!widget.isSavedTimer) {
      items.add(
        new FlatButton(
          child: new Text('Save Timer'),
          onPressed: _showDialog,
        )
      );
    }

    return items;
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
            children: _renderContent(),
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
  final bool isSavedTimer;
  final Settings settings;

  TimerPage({
    Key key,
    @required this.onSave,
    @required this.duration,
    @required this.settings,
    @required this.isSavedTimer,
  }): super(key: key);

  TimerPageState createState() => new TimerPageState(
    tickSound: this.settings.get('tickSound'),
    alarmSound: this.settings.get('alarmSound'),
  );
}
