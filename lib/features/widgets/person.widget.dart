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
      top: top - side,
      left: left - side,
      child: CircleAvatar(
        backgroundColor: Colors.blue[900],
        radius: side,
        child: CircleAvatar(
          radius: side * .8,
          backgroundImage: const AssetImage("assets/images/profile.jpeg"),
        ),
      ),
    );
  }
}
