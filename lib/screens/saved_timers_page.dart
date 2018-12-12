import 'package:flutter/material.dart';

import '../formaters.dart';

class _SavedTimerPageState extends State<SavedTimersPage> {
  void _onDelete(String key) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return new AlertDialog(
            content: new Text('You are going to delete the timer. Are you sure?'),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Cancel'),
                onPressed: () => Navigator.pop(context),
              ),
              new FlatButton(
                child: new Text(
                  'Delete',
                  style: new TextStyle(
                    color: Colors.red,
                  ),
                ),
                onPressed: () {
                  widget.onDelete(key);
                  Navigator.pop(context);
                },
              ),
            ],
          );
        }
    );
  }

  Widget _renderSavedTimers() {
    final items = widget.savedTimers.keys.toList();

    if (items.length == 0) {
      return new Center(
        child: new Text('Empty'),
      );
    }

    return new ListView.builder(
      itemBuilder: (BuildContext context, int index) {

        return new ListTile(
          onTap: () => widget.onStart(widget.savedTimers[items[index]]),
          leading: new Container(
            width: 50,
            child: new Row(
              children: <Widget>[
                new IconButton(
                  icon: new Icon(
                    Icons.delete,
                    color: Colors.black,
                  ),
                  onPressed: () => _onDelete(items[index]),
                ),
              ],
            ),
          ),
          title: new Text(items[index]),
          subtitle: new Text(formatTime(widget.savedTimers[items[index]].inMilliseconds)),
        );
      },
      itemCount: widget.savedTimers.length,
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

class SavedTimersPage extends StatefulWidget {
  final ValueChanged<Duration> onStart;
  final Function onDelete;
  final Map<String, Duration> savedTimers;

  SavedTimersPage({
    Key key,
    @required this.savedTimers,
    @required this.onDelete,
    @required this.onStart,
  }): super(key: key);

  _SavedTimerPageState createState() => new _SavedTimerPageState();
}
