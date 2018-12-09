import 'package:flutter/material.dart';

class ControlPanel extends StatelessWidget {
  final Function onStart;
  final Function onPause;
  final Function onReset;
  final bool isActive;
  final bool isDisabled;

  ControlPanel({
    Key key,
    @required this.onStart,
    @required this.onPause,
    @required this.onReset,
    @required this.isActive,
    @required this.isDisabled,
  }) : super(key: key);

  _renderButtons() {
    var buttons = <Widget>[
      new IconButton(
        onPressed: isDisabled ? null : onReset,
        icon: new Icon(Icons.restore),
      )
    ];

    if (isActive) {
      buttons.add(new IconButton(
        onPressed: isDisabled ? null : onPause,
        icon: new Icon(Icons.pause),
      ));
    } else {
      buttons.add(new IconButton(
        onPressed: isDisabled ? null : onStart,
        icon: new Icon(Icons.play_arrow),
      ));
    }

    return buttons;
  }

  Widget build(BuildContext context) {
    return new Container(
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _renderButtons(),
      ),
    );;
  }
}