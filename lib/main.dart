import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'screens/home_page.dart';
import 'screens/timer_page.dart';

void main() => runApp(new App());

class App extends StatelessWidget {
  Duration _duration;

  Widget build(BuildContext context) {

    return new MaterialApp(
      title: 'Timer',
      initialRoute: '/',
      routes: {
        '/': (context) => new HomePage(onStart: (duration) {
          _duration = duration;
          Navigator.pushNamed(context, '/timer');
        }),
        '/timer': (context) => new TimerPage(
          duration: _duration,
          onFinish: () {
            Navigator.pushNamed(context, '/');
          },
        ),
      }
    );
  }
}
