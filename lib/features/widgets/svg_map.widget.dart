import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mvp_proex/features/model/person.model.dart';
import 'package:mvp_proex/features/widgets/person.widget.dart';
import 'package:mvp_proex/features/widgets/point.widget.dart';

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
  double? top;
  double? left;

  late double scaleFactor;

  bool flag = true;
  bool flagDuration = false;

  late final Widget svg;

  late double objetivoX;
  late double objetivoY;

  List<Map<String, dynamic>> points = [];
  int prev = -1;
  int id = 0;

  @override
  void initState() {
    scaleFactor = widget.svgScale;
    svg = SvgPicture.asset(
      widget.svgPath,
      color: Colors.white,
      fit: BoxFit.none,
    );

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
      body: Transform.scale(
        scale: scaleFactor,
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: flagDuration
                  ? const Duration(milliseconds: 500)
                  : const Duration(milliseconds: 0),
              top: top,
              left: left,
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
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Adicionar ponto $id"),
                          content: Text(
                              "X = ${details.localPosition.dx}\nY = ${details.localPosition.dy}"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                "Cancelar",
                                style: TextStyle(color: Colors.redAccent),
                              ),
                            ),
                            TextButton(
                                onPressed: () {
                                  Map<String, dynamic> json = {
                                    "x": details.localPosition.dx,
                                    "y": details.localPosition.dy,
                                    "prev": prev++,
                                    "id": id++,
                                  };

                                  if (prev < id - 1) {
                                    prev = id - 1;
                                  }

                                  setState(() {
                                    points.add(json);
                                  });
                                  Navigator.pop(context);
                                },
                                child: const Text("Adicionar")),
                          ],
                        );
                      },
                    );
                  }
                },
                child: Container(
                  margin: EdgeInsets.zero,
                  padding: EdgeInsets.zero,
                  child: Stack(
                    children: [
                      svg,
                      PersonWidget(
                        person: widget.person,
                      ),
                      ...points
                          .map<Widget>(
                            (e) => PointWidget(
                              x: e["x"],
                              y: e["y"],
                              side: 5,
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text("Ponto ${e["id"]}"),
                                      content: Text(
                                          "X = ${e["x"]}\nY = ${e["y"]}\nPrev = ${e["prev"]}"),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text(
                                            "Cancelar",
                                            style: TextStyle(
                                                color: Colors.redAccent),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            setState(() {
                                              points.remove(e);
                                            });
                                            Navigator.pop(context);
                                          },
                                          child: const Text(
                                            "Remover",
                                            style: TextStyle(
                                                color: Colors.redAccent),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            prev = e["id"];
                                            Navigator.pop(context);
                                          },
                                          child: const Text(
                                            "Usar como anterior",
                                            style:
                                                TextStyle(color: Colors.green),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            Navigator.pop(context);
                                            int inicio = -1;
                                            int objetivoID = e["id"];
                                            List tracker = [];

                                            // procurar em points o id igual a objetivoID
                                            Map<String, dynamic> point = points
                                                .where((element) =>
                                                    element["id"] == objetivoID)
                                                .first;

                                            // fazer todo o caminho inverso até o ponto com id igual a 1
                                            while (point["id"] != inicio + 1) {
                                              tracker.add(point);
                                              point = points
                                                  .where((element) =>
                                                      element["id"] ==
                                                      point["prev"])
                                                  .first;
                                            }
                                            tracker.add(point);

                                            //inicio
                                            tracker = tracker.reversed.toList();

                                            for (var i = 0;
                                                i < tracker.length;
                                                i++) {
                                              setState(() {
                                                widget.person.setx =
                                                    tracker[i]["x"];
                                                widget.person.sety =
                                                    tracker[i]["y"];
                                              });
                                              await Future.delayed(
                                                  const Duration(seconds: 2));
                                            }
                                          },
                                          child: const Text(
                                            "Objetivo",
                                            style:
                                                TextStyle(color: Colors.yellow),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          )
                          .toList(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
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
              setState(
                () {
                  flagDuration = true;
                  top = ((widget.person.y -
                              MediaQuery.of(context).size.height / 2) +
                          AppBar().preferredSize.height) *
                      -1;
                  left = (widget.person.x -
                          MediaQuery.of(context).size.width / 2) *
                      -1;
                },
              );
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
