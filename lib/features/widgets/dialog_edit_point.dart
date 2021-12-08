import 'package:flutter/material.dart';
import 'package:dijkstra/dijkstra.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future dialogEditPoint(
    BuildContext context,
    var e,
    int id,
    int inicio,
    Function centralizar,
    var widget,
    var points,
    var graph) {
  return showDialog(
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
            onPressed: () async{
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
              int usuarioPos = (prefs.getInt('pos') ?? 0);

              List trackers = Dijkstra.findPathFromGraph(graph, usuarioPos, e["id"]);
              
              List<String> trackersString =
                  trackers.map((i) => i.toString()).toList();

              List<String> tracker = (prefs.getStringList('tracker') ?? []);
              List<int> trackerOriginal =
                  tracker.map((i) => int.parse(i)).toList();
              await prefs.setStringList('tracker', trackersString);

              await prefs.setInt('pos', e["id"]);
              print(trackers);
            },
          ),
        ],
      );
    },
  );
}
