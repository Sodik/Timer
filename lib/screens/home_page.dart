import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../widgets/start_pause_button.dart';
import '../widgets/restore_button.dart';

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

  /*_onVolume() {
    if (_soundOff) {
      tickPlayer.on();
      setState(() {
        _soundOff = false;
      });
    } else {
      tickPlayer.off();
      setState(() {
        _soundOff = true;
      });
    }
  }*/

  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          /*new Container(
            padding: EdgeInsets.only(top: 20.0),
            alignment: Alignment(0.95, 0),
            child: new IconButton(
              icon: new Icon(
                  _soundOff ? Icons.volume_mute : Icons.volume_off
              ),
              onPressed: _onVolume,
            ),
          ),*/
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
            new RestoreButton(
              isActive: _duration.inMilliseconds > 0,
              onClick: _onReset,
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

  HomePage({ Key key, this.onStart }): super(key: key);

  HomePageState createState() => new HomePageState();
}