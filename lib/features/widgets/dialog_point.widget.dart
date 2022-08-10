import 'package:flutter/material.dart';
import 'package:mvp_proex/app/app.constant.dart';
import 'package:dijkstra/dijkstra.dart';

Future dialogPointWidget(BuildContext context, var details, int id, int prev,
    var points, var graph) {
  return showDialog(
    context: context,
    builder: (context) {
      Object? type = TypePoint.path.toString();
      String name = "Caminho";
      return AlertDialog(
        title: Text("Adicionar ponto $id"),
        content: Column(
          children: [
            Text(
                "X = ${details.localPosition.dx}\nY = ${details.localPosition.dy}"),
            DropdownButtonFormField(
              value: type,
              items: [
                DropdownMenuItem(
                  child: const Text("Objetivo"),
                  value: TypePoint.goal.toString(),
                ),
                DropdownMenuItem(
                  child: const Text("Caminho"),
                  value: TypePoint.path.toString(),
                ),
              ],
              onChanged: (value) {
                if (value != TypePoint.goal.toString()) {
                  name = "Caminho";
                } else {
                  name = "Objetivo";
                }
                type = value;
              },
            ),
            TextFormField(
              initialValue: name,
              decoration: const InputDecoration(
                labelText: "Nome do objetivo",
              ),
              onChanged: (value) {
                if (value.isEmpty) {
                  name = "Objetivo $id";
                } else {
                  name = value;
                }
              },
            )
          ],
        ),
        scrollable: true,
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
                /* Calcular o peso das dinstâncias com base na diferença das coordenadas */
                var peso =
                    (details.localPosition.dx - points[prev]["x"]).abs() +
                        (details.localPosition.dy - points[prev]["y"]).abs();
                Map<String, dynamic> json = {
                  "id": id++,
                  "x": details.localPosition.dx,
                  "y": details.localPosition.dy,
                  /*Sempre existirá ao menos um vizinho, que é o ponto anterior*/
                  "vizinhos": {prev++: peso},
                  "type": type,
                  "name": name
                };

                /*O ponto anterior a este deve conter o novo ponto */
                points[prev - 1]["vizinhos"].putIfAbsent(prev, () => peso);
                graph[prev - 1] = points[prev - 1]["vizinhos"];

                if (prev < id - 1) {
                  prev = id - 1;
                }

                graph.putIfAbsent(prev, () => json["vizinhos"]);
                points.add(json);

                print(points);
                print(graph);

                Map graph1 = {
                  10: {11: 1},
                  11: {10: 1, 12: 1},
                  12: {11: 1},
                };

                // print("output2:");
                // print(graph1);
                graph1.forEach((key, value) {
                  graph1[key].remove(11);
                });
                graph1.remove(11);

                graph1.forEach((key, value) {
                  if ((Dijkstra.findPathFromGraph(graph1, key, 0)).isEmpty &&
                      key != 0) {
                    graph1.remove(12);
                  }
                });

                //var output2 = Dijkstra.findPathFromGraph(graph1, from, to);

                //graph1.remove(1);
                //graph1.removeWhere((key, value) => value == 1);
                //print("output2:");
                print(graph1);

                /// output2:
                /// [114, 113, 0, 6, 5]

                Navigator.pop(context);
              },
              child: const Text("Adicionar")),
        ],
      );
    },
  );
}
