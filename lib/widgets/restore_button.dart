import 'package:flutter/material.dart';

class RestoreButton extends StatelessWidget {
  bool isActive;
  Function onClick;

  RestoreButton({
    Key key,
    @required this.isActive,
    @required this.onClick,
  }): super(key: key);

  Widget build(BuildContext context) {
    return new IconButton(
      onPressed: isActive ? onClick : null,
      icon: new Icon(Icons.restore),
    );
  }
}
