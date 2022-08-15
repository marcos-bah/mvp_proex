import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mvp_proex/app/app.constant.dart';

class PointWidget extends StatelessWidget {
  final Map<String, dynamic> json;
  final double side;
  final Function()? onPressed;
  const PointWidget(
      {Key? key, required this.json, required this.side, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: json["y"] - side / 2,
      left: json["x"] - side / 2,
      child: InkWell(
        onTap:
            kIsWeb || Platform.isLinux || Platform.isMacOS || Platform.isWindows
                ? onPressed
                : null,
        child: Container(
          color: json["type"] == TypePoint.path.toString()
              ? Colors.red
              : Colors.green,
          width: side,
          height: side,
        ),
      ),
    );
  }
}
