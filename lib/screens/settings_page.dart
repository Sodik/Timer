import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class SettingsPage extends StatelessWidget {
  final Function onClear;
  final Function onChange;
  final bool tickSound;
  final bool alarmSound;

  SettingsPage({
    Key key,
    this.onClear,
    @required this.onChange,
    @required this.tickSound,
    @required this.alarmSound,
  }): super(key: key);

  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Container(
        padding: EdgeInsets.all(30),
        child: new Column(
          children: <Widget> [
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Text("Play tick sound"),
                new CupertinoSwitch(
                  value: tickSound,
                  onChanged: (bool value){
                    onChange('tickSound', value);
                  },
                ),
              ],
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Text("Play alarm sound"),
                new CupertinoSwitch(
                  value: alarmSound,
                  onChanged: (bool value){
                    onChange('alarmSound', value);
                  },
                ),
              ],
            ),
            new Row(
              children: <Widget>[
                new FlatButton(
                  onPressed: onClear,
                  child: new Text('Clear All Data & Settings'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
