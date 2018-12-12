import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../widgets/start_pause_button.dart';

class HomePageState extends State<HomePage> {
  Duration _duration = Duration(seconds: 0);

  void _setDuration(duration) {
    setState(() {
      _duration = duration;
    });
  }

  void _onStartPause(isStarted) {
    if (isStarted) {
      widget.onStart(_duration);
    }
  }

  void _onReset() {
    setState(() {
      _duration = Duration(seconds: 0);
    });
  }

  Widget build(BuildContext context) {
    return new Scaffold(
      floatingActionButton: widget.hasSavedTimers ? new FloatingActionButton(
        child: new Icon(Icons.view_list),
        onPressed: widget.hasSavedTimers ? () => Navigator.pushNamed(context, '/saved') : null,
      ) : null,
      body: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new Container(
            height: 140.0,
            child: new CupertinoTimerPicker(
              initialTimerDuration: _duration,
              onTimerDurationChanged: _setDuration,
            ),
          ),
        ],
      ),
      bottomNavigationBar: new Container(
        padding: EdgeInsets.only(bottom: 20),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new IconButton(
              onPressed: _duration.inMilliseconds > 0 ? _onReset : null,
              icon: new Icon(Icons.restore),
            ),
            new StartPauseButton(
              isDisabled: _duration.inMilliseconds == 0,
              isActive: false,
              onClick: _onStartPause,
            ),
          ],
        ),
      )
    );
  }
}

class HomePage extends StatefulWidget {
  final ValueChanged<Duration> onStart;
  final bool hasSavedTimers;

  HomePage({
    Key key,
    @required this.onStart,
    @required this.hasSavedTimers,
  }): super(key: key);

  HomePageState createState() => new HomePageState();
}