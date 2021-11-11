import 'package:flutter/material.dart';

class PointValidWidget extends StatelessWidget {
  final double x;
  final double y;
  const PointValidWidget({Key? key, required this.x, required this.y})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: y,
      left: x,
      child: Container(
        color: true ? Colors.red : Colors.green,
        width: side,
        height: side,
      ),
    );
  }
}
