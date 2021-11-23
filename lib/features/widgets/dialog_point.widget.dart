import 'package:flutter/material.dart';
import 'package:mvp_proex/app/app.constant.dart';

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
                Map<String, dynamic> json = {
                  "id": id++,
                  "x": details.localPosition.dx,
                  "y": details.localPosition.dy,
                  "vizinhos": {prev++: 1}, /*Sempre existirá um vizinho, que é o ponto anterior*/
                  "type": type,
                  "name": name
                };
                
                /*O ponto anterior a este deve conter o novo ponto */
                points[prev-1]["vizinhos"].putIfAbsent(prev, () => 1);
                graph[prev-1] = points[prev-1]["vizinhos"];

                if (prev < id - 1) {
                  prev = id - 1;
                }

                graph.putIfAbsent(prev, () => json["vizinhos"]);
                points.add(json);

                print(points);
                print(graph);

                Navigator.pop(context);
              },
              child: const Text("Adicionar")),
        ],
      );
    },
  );
}
