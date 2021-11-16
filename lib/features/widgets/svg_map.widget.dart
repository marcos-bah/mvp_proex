import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter_svg/svg.dart';
import 'package:mvp_proex/app/app.constant.dart';
import 'package:mvp_proex/features/model/person.model.dart';
import 'package:mvp_proex/features/widgets/custom_appbar.widget.dart';
import 'package:mvp_proex/features/widgets/dialog_edit_point.dart';
import 'package:mvp_proex/features/widgets/dialog_point.widget.dart';
import 'package:mvp_proex/features/widgets/person.widget.dart';
import 'package:mvp_proex/features/widgets/point.widget.dart';
import 'package:mvp_proex/features/widgets/point_valid.widget.dart';

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

  /// Define a origem o personagem no SVG
  /// Por padrão ele é 0
  ///
  /// ```dart
  /// SVGMap(
  ///   ...
  ///   person: person,
  ///   ...
  /// ),
  /// ```
  final PersonModel person;

  const SVGMap({
    Key? key,
    required this.svgPath,
    required this.svgWidth,
    required this.svgHeight,
    this.svgScale = 1,
    required this.person,
  }) : super(key: key);

  @override
  State<SVGMap> createState() => _SVGMapState();
}

class _SVGMapState extends State<SVGMap> {
  bool isAdmin = false;

  double? top, x;
  double? left, y;

  late double scaleFactor;

  bool flag = true;
  bool flagDuration = false;

  late final Widget svg;

  late double objetivoX;
  late double objetivoY;

  int prev = -1;
  int id = 0;
  int inicio = 0;
  List<Map<String, dynamic>> points = [];

  void centralizar(bool flag) {
    setState(() {
      flagDuration = flag;
      top = ((widget.person.y - MediaQuery.of(context).size.height / 2) +
              AppBar().preferredSize.height) *
          -1;
      left = (widget.person.x - MediaQuery.of(context).size.width / 2) * -1;
    });
  }

  @override
  void initState() {
    scaleFactor = widget.svgScale;
    svg = SvgPicture.asset(
      widget.svgPath,
      color: Colors.white,
      fit: BoxFit.none,
    );
    // ignore: unused_local_variable
    Map<String, dynamic> json = {
      "id": id++,
      "x": widget.person.x,
      "y": widget.person.y,
      "prev": prev++,
      "type": TypePoint.goal.toString(),
      "name": "Entrada Reitoria"
    };

    points.add(json);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (left == null && top == null) {
      top = ((widget.person.y - MediaQuery.of(context).size.height / 2) +
              AppBar().preferredSize.height) *
          -1;
      left = (widget.person.x - MediaQuery.of(context).size.width / 2) * -1;
    }
    return Scaffold(
      appBar: CustomAppBar(
        height: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.home_work,
              size: 30,
              color: Colors.white,
            ),
            SizedBox(
              width: 20,
            ),
            Text(
              "Entrada Reitoria",
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      body: Transform.rotate(
        angle: math.pi / 0.5,
        child: Transform.scale(
          scale: scaleFactor,
          child: Stack(
            children: [
              AnimatedPositioned(
                duration: flagDuration
                    ? const Duration(milliseconds: 500)
                    : const Duration(milliseconds: 0),
                top: top,
                left: left,
                child: MouseRegion(
                  onHover: (event) {
                    if (isAdmin) {
                      setState(() {
                        x = event.localPosition.dx;
                        y = event.localPosition.dy;
                      });
                    }
                  },
                  child: GestureDetector(
                    onDoubleTap: () {
                      setState(
                        () {
                          if (flag) {
                            scaleFactor *= 2;
                            flag = false;
                          } else {
                            scaleFactor *= 1 / 2;
                            flag = true;
                          }
                        },
                      );
                    },
                    onPanUpdate: (details) {
                      setState(
                        () {
                          flagDuration = false;
                          top = top! + details.delta.dy;
                          left = left! + details.delta.dx;
                        },
                      );
                    },
                    onLongPressEnd: (details) {
                      setState(
                        () {
                          objetivoX = details.localPosition.dx;
                          objetivoY = details.localPosition.dy;

                          setState(
                            () {
                              setState(() {
                                widget.person.setx = objetivoX;
                                widget.person.sety = objetivoY;
                              });
                            },
                          );
                        },
                      );
                    },
                    onSecondaryTapDown: (details) {
                      if (Platform.isLinux ||
                          Platform.isMacOS ||
                          Platform.isWindows) {
                        //somente desktop
                        dialogPointWidget(context, details, id, prev, points)
                            .whenComplete(() => setState(() {}));
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.zero,
                      padding: EdgeInsets.zero,
                      child: Stack(
                        children: [
                          svg,

                          ...points
                              .map<Widget>(
                                (e) => PointWidget(
                                  json: e,
                                  side: 5,
                                  onPressed: () {
                                    if (Platform.isLinux ||
                                        Platform.isMacOS ||
                                        Platform.isWindows) {
                                      //somente desktop
                                      dialogEditPoint(context, e, id, prev,
                                          inicio, centralizar, widget, points);
                                    }
                                  },
                                ),
                              )
                              .toList(),

                          PersonWidget(
                            person: widget.person,
                          ),
                          ...pointValidWidget(
                            x: x ?? 0,
                            y: y ?? 0,
                            width: widget.svgWidth,
                            height: widget.svgHeight,
                            lastPoint: points.last,
                          ),
                          // fazer uma cruz no centro
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          (Platform.isLinux || Platform.isMacOS || Platform.isWindows)
              ? FloatingActionButton(
                  backgroundColor: Colors.red[900],
                  onPressed: () {
                    setState(
                      () {
                        isAdmin = !isAdmin;
                        // criar scaffold message
                        ScaffoldMessenger.of(context).removeCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              isAdmin
                                  ? 'Modo Admin Ativado'
                                  : 'Modo Admin Desativado',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: const Icon(
                    Icons.admin_panel_settings,
                    size: 30,
                  ),
                )
              : Container(),
          const SizedBox(
            height: 20,
          ),
          FloatingActionButton(
            onPressed: () {
              setState(
                () {
                  if (flag) {
                    scaleFactor *= 2;
                    flag = false;
                  } else {
                    scaleFactor *= 1 / 2;
                    flag = true;
                  }
                },
              );
            },
            child: Icon(
              flag ? Icons.zoom_in_sharp : Icons.zoom_out_map,
              size: 30,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          FloatingActionButton(
            onPressed: () {
              centralizar(true);
            },
            child: const Icon(
              Icons.center_focus_strong,
              size: 30,
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 20,
        ),
        margin: const EdgeInsets.all(16),
        height: 80,
        width: 100,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(25)),
          color: Colors.deepOrange,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Icon(
              Icons.arrow_upward_outlined,
              size: 40,
              color: Colors.white,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                Icon(
                  Icons.social_distance,
                  color: Colors.white,
                ),
                Text("2 Km"),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                Icon(
                  Icons.timelapse,
                  color: Colors.white,
                ),
                Text("1 min"),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                Icon(
                  Icons.timer,
                  color: Colors.white,
                ),
                Text("10:56"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
