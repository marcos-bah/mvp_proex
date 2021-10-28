import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mvp_proex/features/widgets/person.widget.dart';

class MapTestView extends StatefulWidget {
  const MapTestView({Key? key}) : super(key: key);

  @override
  State<MapTestView> createState() => _MapTestViewState();
}

class _MapTestViewState extends State<MapTestView> {
  Offset offset = const Offset(0, 0);
  //639.594,274.301
  Offset offset2 = const Offset(639.594, 274.301);
  double scaleFactor = 1;
  bool flag = true;
  @override
  Widget build(BuildContext context) {
    //mapa
    const Offset tam = Offset(
      800,
      600,
    );

    double x = tam.dx;
    double y = tam.dy;

    const String assetName = "assets/maps/reitoria/mapaTeste.svg";

    final Widget svg = SvgPicture.asset(
      assetName,
      color: Colors.blue[900],
      width: 800,
      height: 600,
      fit: BoxFit.none,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa Teste'),
        centerTitle: true,
      ),
      body: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            offset += details.delta;
            if (MediaQuery.of(context).size.width <= x) {
              x = MediaQuery.of(context).size.width - 100;
            } else {
              x = 800;
            }

            if (MediaQuery.of(context).size.height <= y) {
              y = MediaQuery.of(context).size.height - 100;
            } else {
              y = 600;
            }

            // limit
            offset = Offset(
              offset.dx.clamp(-(x / 2), x / 2),
              offset.dy.clamp(-(y / 2), y / 2),
            );
          });
        },
        onDoubleTap: () {
          setState(() {
            if (flag) {
              scaleFactor *= 2;
              flag = false;
            } else {
              scaleFactor *= 1 / 2;
              flag = true;
            }
          });
        },
        child: Transform.scale(
          scale: scaleFactor,
          child: Expanded(
            child: Transform.translate(
              offset: offset,
              child: Container(
                margin: EdgeInsets.zero,
                padding: EdgeInsets.zero,
                height: 900,
                width: 900,
                color: Colors.red,
                child: svg,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
