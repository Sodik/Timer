import 'package:flutter/material.dart';

import '../formaters.dart';

class SavedTimersPage extends StatelessWidget {
  final ValueChanged<Duration> onStart;
  final Function onDelete;
  final Map<String, Duration> savedTimers;

  SavedTimersPage({
    Key key,
    @required this.savedTimers,
    @required this.onDelete,
    @required this.onStart,
  }): super(key: key);

  Widget _renderSavedTimers() {
    final items = savedTimers.keys.toList();

    if (items.length == 0) {
      return new Center(
        child: new Text('Empty'),
      );
    }

    return new ListView.builder(
      itemBuilder: (BuildContext context, int index) {

        return new ListTile(
          leading: new Container(
            width: 100,
            child: new Row(
              children: <Widget>[
                new IconButton(
                  icon: new Icon(Icons.delete),
                  onPressed: () => onDelete(items[index]),
                ),
                new IconButton(
                  icon: new Icon(Icons.play_arrow),
                  onPressed: () {
                    onStart(savedTimers[items[index]]);
                  },
                ),
              ],
            ),
          ),
          title: new Text(items[index]),
          subtitle: new Text(formatTime(savedTimers[items[index]].inMilliseconds)),
        );
      },
      itemCount: savedTimers.length,
    );
  }

  Widget build(BuildContext context) {
    return new Scaffold(
      body: _renderSavedTimers(),
      bottomNavigationBar: new Container(
        padding: EdgeInsets.only(bottom: 20),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new IconButton(
              icon: new Icon(Icons.home),
              onPressed: () => Navigator.pushNamed(context, '/'),
            )
          ],
        ),
      ),
    );
  }
}
