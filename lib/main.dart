import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/home_page.dart';
import 'screens/timer_page.dart';
import 'screens/saved_timers_page.dart';
import 'formaters.dart';

void main() async {
  final storage = await SharedPreferences.getInstance();

  runApp(new App(storage: storage));
}

class _AppState extends State<App> {
  Duration _duration;
  bool _isSavedTimer = false;

  _onSave(String name, String duration) {
    setState(() {
      widget.storage.setString(name, duration);
    });
  }

  _onDelete(String key) {
    setState(() {
      widget.storage.remove(key);
    });
  }

  Map<String, Duration> get _savedTimers{
    var items = new Map<String, Duration>();
    var keys = widget.storage.getKeys();

    for (var key in keys) {
      items.putIfAbsent(key, () => stringToDuration(widget.storage.getString(key)));
    }

    return items;
  }

  bool get _hasSavedTimers{
    return widget.storage.getKeys().length > 0;
  }

  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Timer',
      initialRoute: '/',
      routes: {
        '/': (context) => new HomePage(
          hasSavedTimers: _hasSavedTimers,
          onStart: (Duration duration) {
            _duration = duration;
            _isSavedTimer = false;
            Navigator.pushNamed(context, '/timer');
          },
        ),
        '/timer': (context) => new TimerPage(
          duration: _duration,
          isSavedTimer: _isSavedTimer,
          onSave: (String name, String duration) {
            _onSave(name, duration);
          },
        ),
        '/saved': (context) => new SavedTimersPage(
          onDelete: _onDelete,
          onStart: (Duration duration) {
            _duration = duration;
            _isSavedTimer = true;
            Navigator.pushNamed(context, '/timer');
          },
          savedTimers: _savedTimers,
        ),
      }
    );
  }
}

class App extends StatefulWidget {
  final SharedPreferences storage;

  App({
    Key key,
    @required this.storage,
  }): super(key: key);

  _AppState createState() => new _AppState();
}
