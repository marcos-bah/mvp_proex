import 'package:flutter/material.dart';

class PersonWidget extends StatelessWidget {
  final double top, left;
  final double side;
  const PersonWidget(
      {Key? key, this.side = 10, required this.top, required this.left})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // offset to center, side is 10

    return Positioned(
      top: top - side / 2,
      left: left - side / 2,
      child: Container(
        height: side,
        width: side,
        color: Colors.red,
      ),
    );
  }
}
