import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mvp_proex/features/widgets/person.widget.dart';
import 'package:mvp_proex/features/widgets/svg_map.widget.dart';

class MapTestView extends StatefulWidget {
  const MapTestView({Key? key}) : super(key: key);

  @override
  State<MapTestView> createState() => _MapTestViewState();
}

class _MapTestViewState extends State<MapTestView> {
  double scaleFactor = 1.5;
  bool flag = true;
  double top = 86, left = -455.5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa Teste'),
        centerTitle: true,
      ),
      body: const SVGMap(
        svgPath: "assets/maps/reitoria/mapaTeste.svg",
        svgWidth: 800,
        svgHeight: 600,
        svgScale: 1.3,
        originY: 274,
        originX: 639,
      ),
    );
  }
}
