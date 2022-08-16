import 'package:flutter/material.dart';
import 'package:mvp_proex/features/person/person.model.dart';

class PersonWidget extends StatelessWidget {
  final PersonModel person;
  final double side;
  const PersonWidget({Key? key, this.side = 10, required this.person})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // offset to center, side is 10

    return AnimatedPositioned(
      duration: const Duration(seconds: 2),
      top: person.y - side,
      left: person.x - side,
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
