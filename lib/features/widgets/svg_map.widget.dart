import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter_svg/svg.dart';
import 'package:mvp_proex/features/model/person.model.dart';
import 'package:mvp_proex/features/widgets/custom_appbar.widget.dart';
import 'package:mvp_proex/features/widgets/person.widget.dart';
import 'package:mvp_proex/features/widgets/point.widget.dart';
import 'package:mvp_proex/features/widgets/top_navigation.widget.dart';

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
      "x": widget.person.x,
      "y": widget.person.y,
      "prev": prev++,
      "id": id++,
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
                                            onPressed: e["id"] == id
                                                ? () {
                                                    setState(() {
                                                      points.remove(e);
                                                    });
                                                    Navigator.pop(context);
                                                  }
                                                : null,
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
                                              style: TextStyle(
                                                  color: Colors.green),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              // TODO: Caminho melhor
                                              // fechar pop up
                                              Navigator.pop(context);

                                              // lista do caminho a ser seguido
                                              List tracker = [];

                                              // pegando o ponto inicial
                                              Map pointInit = points
                                                  .where((element) =>
                                                      element["x"] ==
                                                          widget.person.x &&
                                                      element["y"] ==
                                                          widget.person.y)
                                                  .first;

                                              bool flag =
                                                  pointInit["id"] > e["id"];

                                              // traçar o caminho, caso o caminho seja de volta
                                              while (
                                                  pointInit["id"] != e["id"]) {
                                                if (flag) {
                                                  pointInit = points
                                                      .where((element) =>
                                                          element["id"] ==
                                                          pointInit["prev"])
                                                      .first;
                                                  tracker.add(pointInit);
                                                } else {
                                                  tracker.add(e);
                                                  e = points
                                                      .where((element) =>
                                                          element["id"] ==
                                                          e["prev"])
                                                      .first;
                                                }
                                              }

                                              //inicio
                                              if (flag) {
                                                tracker.add(e);
                                              } else {
                                                tracker =
                                                    tracker.reversed.toList();
                                              }

                                              print(tracker);

                                              for (var i = 0;
                                                  i < tracker.length;
                                                  i++) {
                                                setState(() {
                                                  widget.person.setx =
                                                      tracker[i]["x"];
                                                  widget.person.sety =
                                                      tracker[i]["y"];
                                                  inicio = tracker[i]["id"];
                                                });

                                                await Future.delayed(
                                                    const Duration(seconds: 2));
                                                centralizar(true);
                                              }
                                            },
                                            child: const Text(
                                              "Objetivo",
                                              style: TextStyle(
                                                  color: Colors.deepPurple),
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
