import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../managers/setttings.dart';

class _SettingsPageState extends State<SettingsPage> {
  final Settings settings;

  _SettingsPageState({
    @required this.settings,
  });

  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Container(
        padding: EdgeInsets.all(30),
        child: new Column(
          children: <Widget>[
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Text("Play tick sound"),
                new CupertinoSwitch(
                  value: settings.get('tickSound'),
                  onChanged: (bool value){
                    setState(() {
                      settings.set('tickSound', value);
                    });
                  },
                ),
              ],
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Text("Play alarm sound"),
                new CupertinoSwitch(
                  value: settings.get('alarmSound'),
                  onChanged: (bool value){
                    setState(() {
                      settings.set('alarmSound', value);
                    });
                  },
                ),
              ],
            ),
            new Row(
              children: <Widget>[
                new FlatButton(
                  onPressed: widget.onClear,
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

class SettingsPage extends StatefulWidget {
  final Function onClear;
  final Settings settings;

  SettingsPage({
    Key key,
    @required this.settings,
    @required this.onClear,
  }): super(key: key);

  _SettingsPageState createState() => new _SettingsPageState(
    settings: this.settings,
  );
}
