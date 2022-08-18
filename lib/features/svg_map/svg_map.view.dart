import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter_svg/svg.dart';
import 'package:mvp_proex/app/app.constant.dart';
import 'package:mvp_proex/features/person/person.model.dart';
import 'package:mvp_proex/features/person/person.widget.dart';
import 'package:mvp_proex/features/point/point.model.dart';
import 'package:mvp_proex/features/point/point.widget.dart';
import 'package:mvp_proex/features/point/point.repository.dart';
import 'package:mvp_proex/features/widgets/point_valid.widget.dart';
import 'package:mvp_proex/features/widgets/custom_appbar.widget.dart';
import 'package:mvp_proex/features/widgets/dialog_edit_point.dart';
import 'package:mvp_proex/features/widgets/dialog_point.widget.dart';
import 'package:mvp_proex/features/widgets/qrcode_scanner.widget.dart';

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
  bool isLine = true;

  double? top, x;
  double? left, y;

  late double scaleFactor;

  // TODO: mudar de flag para flagScale?
  bool flagScale = true;
  bool flagDuration = false;

  late final Widget svg;

  late double objetivoX;
  late double objetivoY;

  int prev = 0;
  int id = 0;
  int inicio = 0;
  // TODO: mudar de points para pointList?
  List<Map<String, dynamic>> pointList = [];
  List<PointModel> newPointList = [];
  Map graph = {};

  void centralizar(bool flagScale) {
    setState(() {
      flagDuration = flagScale;
      top = ((widget.person.y - MediaQuery.of(context).size.height / 2) +
              2 * AppBar().preferredSize.height) *
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

    var allPoints = PointRepository();
    allPoints.getAllPoints(
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6Imx1Y2FzQHVuaWZlaS5iciIsImlhdCI6MTY2MDI1ODg2NywiZXhwIjoxNjYwMzQ1MjY3LCJzdWIiOiIwZjQwYjJlMS01N2YwLTRlMTMtOTQ5ZS1mYWVkOWE1OGMxYWUifQ.mjaONFf16HNGEKvEwCbC93MehwHRVBqEWbhg0PVbQ8M");

    var point = PointModel();
    point.id = id;
    point.x = widget.person.x;
    point.y = widget.person.y;
    point.neighbor = {};
    point.description =
        "Prédio em que se concentra a maior parte das atividades administrativas da universidade, como matrícula ou trancamento";
    point.type = TypePoint.goal;
    point.name = "Entrada Reitoria";

    Map<String, dynamic> json = {
      "id": id++,
      "x": widget.person.x,
      "y": widget.person.y,
      "vizinhos": {},
      "descricao":
          "Prédio em que se concentra a maior parte das atividades administrativas da universidade, como matrícula ou trancamento",
      "type": TypePoint.goal.toString(),
      "name": "Entrada Reitoria"
    };

    graph[0] = {};
    pointList.add(json);
    newPointList.add(point);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isValidX = (pointList.last["x"] > ((x ?? 1) - 1) &&
        pointList.last["x"] < ((x ?? 0) + 1));

    bool isValidY = (pointList.last["y"] > ((y ?? 1)) - 1 &&
        pointList.last["y"] < ((y ?? 0) + 1));

    bool isValid = isValidX || isValidY;

    if (left == null && top == null) {
      top = ((widget.person.y - MediaQuery.of(context).size.height / 2) +
              AppBar().preferredSize.height) *
          -1;
      left = (widget.person.x - MediaQuery.of(context).size.width / 2) * -1;
    }
    return Scaffold(
      appBar: CustomAppBar(
        height: 100,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Row(
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
            //Caso queira navegar para outra página
            Positioned(
              top: -10,
              left: 0,
              child: IconButton(
                icon: const Icon(
                  Icons.qr_code_outlined,
                  size: 35,
                  color: Colors.white,
                ),
                onPressed: () {
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => Qrcodescannermvp()));
                },
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
                          if (flagScale) {
                            scaleFactor *= 2;
                            flagScale = false;
                          } else {
                            scaleFactor *= 1 / 2;
                            flagScale = true;
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

                          widget.person.setx = objetivoX;
                          widget.person.sety = objetivoY;
                        },
                      );
                    },
                    // TODO: mudar para TapDown?
                    onTapDown: (details) {
                      if (isAdmin && isValid) {
                        dialogPointWidget(
                                context, details, id, pointList, graph)
                            .whenComplete(
                          () => setState(
                            () {
                              id++;
                              prev++;
                            },
                          ),
                        );
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.zero,
                      padding: EdgeInsets.zero,
                      child: Stack(
                        children: [
                          svg,
                          if (isAdmin)
                            ...pointList
                                .map<Widget>(
                                  (e) => PointWidget(
                                    json: e,
                                    side: 5,
                                    onPressed: () {
                                      if (isAdmin) {
                                        //somente desktop

                                        dialogEditPoint(
                                            context,
                                            e,
                                            id,
                                            prev,
                                            inicio,
                                            centralizar,
                                            widget,
                                            pointList,
                                            graph);
                                      }
                                    },
                                  ),
                                )
                                .toList(),
                          PersonWidget(
                            person: widget.person,
                          ),
                          if (isAdmin && isLine)
                            ...pointValidWidget(
                              x: x ?? 0,
                              y: y ?? 0,
                              width: widget.svgWidth,
                              height: widget.svgHeight,
                              lastPoint: pointList.last,
                              isValidX: isValidX,
                              isValidY: isValidY,
                            ),
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
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          isAdmin
              ? FloatingActionButton(
                  heroTag: "btnLine",
                  onPressed: () {
                    setState(
                      () {
                        isLine = !isLine;
                      },
                    );
                  },
                  child: const Icon(
                    Icons.line_style,
                    size: 30,
                  ),
                )
              : Container(),
          isAdmin
              ? const SizedBox(
                  height: 20,
                )
              : Container(),
          (kIsWeb || Platform.isLinux || Platform.isMacOS || Platform.isWindows)
              ? FloatingActionButton(
                  heroTag: "btnAdmin",
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
            heroTag: "btnScale",
            onPressed: () {
              setState(
                () {
                  if (flagScale) {
                    scaleFactor *= 2;
                    flagScale = false;
                  } else {
                    scaleFactor *= 1 / 2;
                    flagScale = true;
                  }
                },
              );
            },
            child: Icon(
              flagScale ? Icons.zoom_in_sharp : Icons.zoom_out_map,
              size: 30,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          FloatingActionButton(
            heroTag: "btnCentralizar",
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
      ///// Não ficará visível para o administrador
      // bottomNavigationBar: Container(
      //   padding: const EdgeInsets.symmetric(
      //     vertical: 10,
      //     horizontal: 20,
      //   ),
      //   margin: const EdgeInsets.all(16),
      //   height: 80,
      //   width: 100,
      //   decoration: const BoxDecoration(
      //     borderRadius: BorderRadius.all(Radius.circular(25)),
      //     color: Colors.deepOrange,
      //   ),
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //     children: [
      //       const Icon(
      //         Icons.arrow_upward_outlined,
      //         size: 40,
      //         color: Colors.white,
      //       ),
      //       Column(
      //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //         children: const [
      //           Icon(
      //             Icons.social_distance,
      //             color: Colors.white,
      //           ),
      //           Text("2 Km"),
      //         ],
      //       ),
      //       Column(
      //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //         children: const [
      //           Icon(
      //             Icons.timelapse,
      //             color: Colors.white,
      //           ),
      //           Text("1 min"),
      //         ],
      //       ),
      //       Column(
      //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //         children: const [
      //           Icon(
      //             Icons.timer,
      //             color: Colors.white,
      //           ),
      //           Text("10:56"),
      //         ],
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}
