import 'package:flutter/material.dart';

class StartPauseButton extends StatelessWidget {
  bool isActive;
  bool isDisabled;
  ValueChanged<bool> onClick;

  StartPauseButton({
    Key key,
    @required this.isActive,
    @required this.isDisabled,
    @required this.onClick,
  }): super(key: key);

  Widget build(BuildContext context) {
    if (isActive) {
      return new IconButton(
        onPressed: isDisabled ? null : () => onClick(false),
        icon: new Icon(Icons.pause),
      );
    }

    return new IconButton(
      onPressed: isDisabled ? null : () => onClick(true),
      icon: new Icon(Icons.play_arrow),
    );
  }
}