import 'package:flutter/material.dart';

class PersonWidget extends StatelessWidget {
  final Offset offset;
  final double side;
  const PersonWidget({Key? key, required this.offset, this.side = 10})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // offset to center, side is 10

    return Transform.translate(
      offset: Offset(offset.dx - side / 2, offset.dy - side / 2),
      child: Container(
        height: side,
        width: side,
        color: Colors.red,
      ),
    );
  }
}
