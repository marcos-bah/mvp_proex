import 'package:flutter/material.dart';
import 'package:dijkstra/dijkstra.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future dialogEditPoint(BuildContext context, var e, int id, int inicio,
    Function centralizar, var widget, var points, var graph) async {
  bool flag = false;
  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("Ponto ${e["id"]}"),
        content:
            Text("X = ${e["x"]}\nY = ${e["y"]}\nVizinhos = ${e["vizinhos"]}"),
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
            onPressed: e["id"] == id
                ? () {
                    points.remove(e);

                    Navigator.pop(context);
                  }
                : null,
            child: const Text(
              "Remover",
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
          TextButton(
            onPressed: () async {
              flag = true;
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setInt('prev', e["id"]);
              Navigator.pop(context);
            },
            child: const Text(
              "Usar como anterior",
              style: TextStyle(color: Colors.green),
            ),
          ),
          TextButton(
            child: const Text(
              "Objetivo",
              style: TextStyle(color: Colors.deepPurple),
            ),
            onPressed: () async {
              // TODO: Caminho melhor
              // fechar pop up
              Navigator.pop(context);
              SharedPreferences prefs = await SharedPreferences.getInstance();
              // lista do caminho a ser seguido
              int usuarioPos = inicio;

              List trackers =
                  Dijkstra.findPathFromGraph(graph, usuarioPos, e["id"]);

              List<String> trackersString =
                  trackers.map((i) => i.toString()).toList();

              List<String> tracker = (prefs.getStringList('tracker') ?? []);
              List<int> trackerOriginal =
                  tracker.map((i) => int.parse(i)).toList();
              await prefs.setStringList('tracker', trackersString);

              await prefs.setInt('pos', e["id"]);
              print("estou em: ${inicio}");
              var json;
              for (var i = 1; i < trackers.length; i++) {
                json = points.firstWhere((ob) => ob["id"] == trackers[i]);
                print(json);
                widget.person.setx = json["x"];
                widget.person.sety = json["y"];
                inicio = json["id"];
                await Future.delayed(const Duration(seconds: 3)).then((value) {
                  // centralizar(true);
                });
              }

              print("estou agr em: ${json["id"]}");
              print("percorreu: ${trackersString}");
            },
          ),
          TextButton(
            child: const Text(
              "Tornar vizinho",
              style: TextStyle(color: Colors.redAccent),
            ),
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();

              int prev = (prefs.getInt('prev') ?? 0);
              print(prev);
              int peso = ((e["x"] - points[prev]["x"]).abs() +
                      (e["y"] - points[prev]["y"]).abs())
                  .round();

              /*O ponto anterior a este deve conter o novo ponto */

              points[e["id"]]["vizinhos"].putIfAbsent(prev, () => peso);
              points[prev]["vizinhos"].putIfAbsent(e["id"], () => peso);
              graph[prev] = points[prev]["vizinhos"];

              graph.putIfAbsent(e["id"], () => e["id"]["vizinhos"]);

              await prefs.setInt('prev', e["id"]);
              print(points);
              print(graph);
            },
          ),
        ],
      );
    },
  );
  return Future.delayed(Duration(milliseconds: 0)).then((value) => flag);
}
