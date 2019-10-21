import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/home_page.dart';
import 'screens/timer_page.dart';
import 'screens/saved_timers_page.dart';
import 'screens/settings_page.dart';

import 'managers/setttings.dart';
import 'managers/saved_timers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storage = await SharedPreferences.getInstance();

  runApp(new App(
    storage: storage,
  ));
}

class _AppState extends State<App> {
  Duration _duration;
  bool _isSavedTimer = false;
  Settings _settings;
  SavedTimers _timers;

  void initState() {
    super.initState();

    _settings = new Settings(
      storage: widget.storage,
    );
    _timers = new SavedTimers(
      storage: widget.storage,
    );
  }

  void _onSave(String name, String duration) {
    setState(() {
      _isSavedTimer = true;
      _timers.set(name, duration);
    });
  }

  void _onDelete(String key) {
    setState(() {
     _timers.remove(key);
    });
  }

  Map<String, Duration> get _savedTimers{
    return _timers.items;
  }

  bool get _hasSavedTimers {
    return _savedTimers.length > 0;
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
          settings: _settings,
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
        '/settings': (context) => new SettingsPage(
          tickSound: _settings.get('tickSound'),
          alarmSound: _settings.get('alarmSound'),
          onChange: (String key, bool value) {
            setState(() {
              _settings.set(key, value);
            });
          },
          onClear: widget.storage.getKeys().length > 0 ? (){
            setState(() {
              widget.storage.clear();
            });
          } : null,
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
