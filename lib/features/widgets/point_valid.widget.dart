import 'package:flutter/material.dart';

List<Positioned> pointValidWidget({
  required double x,
  required double y,
  required double width,
  required double height,
  var lastPoint,
}) {
  print(lastPoint);
  print(x);
  return [
    Positioned(
      top: y,
      left: 0,
      child: Container(
        width: width,
        height: 1,
        decoration: BoxDecoration(
          color: lastPoint == null
              ? Colors.green
              : (lastPoint["y"] > y - 1 && lastPoint["y"] < y + 1)
                  ? Colors.green
                  : Colors.red,
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    ),
    Positioned(
      top: 0,
      left: x,
      child: Container(
        width: 1,
        height: height,
        decoration: BoxDecoration(
          color: lastPoint == null
              ? Colors.green
              : (lastPoint["x"] > x - 1 && lastPoint["x"] < x + 1)
                  ? Colors.green
                  : Colors.red,
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    ),
  ];
}
