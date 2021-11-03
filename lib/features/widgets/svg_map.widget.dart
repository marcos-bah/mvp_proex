import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mvp_proex/features/widgets/person.widget.dart';

class SVGMap extends StatefulWidget {
  /// Define o caminho do asset:
  ///
  /// ```dart
  /// SVGMap(
  ///   svgPath: "assets/maps/reitoria/mapaTeste.svg",
  ///   ...
  /// ),
  /// ```
  final String svgPath;

  /// Define a largura do SVG, em pixel
  ///
  /// ```dart
  /// SVGMap(
  ///   ...
  ///   svgWidth: 800,
  ///   ...
  /// ),
  /// ```
  final double svgWidth;

  /// Define a altura do SVG, em pixel
  ///
  /// ```dart
  /// SVGMap(
  ///   ...
  ///   svgHeight: 600,
  ///   ...
  /// ),
  /// ```
  final double svgHeight;

  /// Define a scala inicial do SVG, em pixel
  /// Por padrão ele é 1.0
  ///
  /// ```dart
  /// SVGMap(
  ///   ...
  ///   svgScale: 1.1,
  ///   ...
  /// ),
  /// ```
  final double svgScale;

  /// Define a origem em X, o centro do svg.
  /// Por padrão ele é 0
  ///
  /// ```dart
  /// SVGMap(
  ///   ...
  ///   originX: 274,
  ///   ...
  /// ),
  /// ```
  final double originX;

  /// Define a origem em Y, o centro do svg.
  /// Por padrão ele é 0
  ///
  /// ```dart
  /// SVGMap(
  ///   ...
  ///   originY: 274,
  ///   ...
  /// ),
  /// ```
  final double originY;

  const SVGMap({
    Key? key,
    required this.svgPath,
    required this.svgWidth,
    required this.svgHeight,
    this.svgScale = 1,
    this.originX = 0,
    this.originY = 0,
  }) : super(key: key);

  @override
  State<SVGMap> createState() => _SVGMapState();
}

class _SVGMapState extends State<SVGMap> {
  double? top;
  double? left;

  late double scaleFactor;

  bool flag = true;

  late final Widget svg;

  late double localPosX;
  late double localPosY;

  @override
  void initState() {
    scaleFactor = widget.svgScale;
    svg = SvgPicture.asset(
      widget.svgPath,
      color: Colors.blue[900],
      fit: BoxFit.none,
    );

    localPosX = widget.originX;
    localPosY = widget.originY;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (left == null && top == null) {
      top = (localPosY - MediaQuery.of(context).size.height / 2) * -1;
      left = (localPosX - MediaQuery.of(context).size.width / 2) * -1;
    }
    return Scaffold(
      body: GestureDetector(
        onPanUpdate: (details) {
          setState(
            () {
              top = top! + details.delta.dy;
              left = left! + details.delta.dx;
            },
          );
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
        onPanDown: (details) {
          setState(
            () {},
          );
        },
        child: Transform.scale(
          scale: scaleFactor,
          child: Stack(
            children: [
              Positioned(
                top: top,
                left: left,
                child: Container(
                  margin: EdgeInsets.zero,
                  padding: EdgeInsets.zero,
                  child: Stack(
                    children: [
                      svg,
                      PersonWidget(
                        top: localPosY,
                        left: localPosX,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(
            () {
              top = (localPosY - MediaQuery.of(context).size.height / 2) * -1;
              left = (localPosX - MediaQuery.of(context).size.width / 2) * -1;
            },
          );
        },
        child: const Icon(
          Icons.center_focus_strong,
          size: 30,
        ),
      ),
    );
  }
}
