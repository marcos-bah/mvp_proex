import 'dart:io';

import 'package:flutter/material.dart';

class PointWidget extends StatelessWidget {
  final double x;
  final double y;
  final double side;
  final Function()? onPressed;
  const PointWidget(
      {Key? key,
      required this.x,
      required this.y,
      required this.side,
      this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: y - side / 2,
      left: x - side / 2,
      child: InkWell(
        onTap: Platform.isLinux || Platform.isMacOS || Platform.isWindows
            ? onPressed
            : null,
        child: Container(
          color: Colors.red,
          width: side,
          height: side,
        ),
      ),
    );
  }
}
