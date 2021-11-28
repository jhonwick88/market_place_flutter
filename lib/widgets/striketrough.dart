import 'package:flutter/material.dart';

class StrikeThroughWidget extends StatelessWidget {
  final Widget _child;

  StrikeThroughWidget({Key? key, required Widget child})
      : this._child = child,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _child,
      padding: EdgeInsets.symmetric(
          horizontal:
              8), // this line is optional to make strikethrough effect outside a text
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('images/strikethrough.png'),
            fit: BoxFit.fitWidth),
      ),
    );
  }
}
