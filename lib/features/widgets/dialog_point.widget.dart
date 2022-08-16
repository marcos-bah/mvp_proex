import 'package:flutter/material.dart';
import 'package:mvp_proex/app/app.constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future dialogPointWidget(
    BuildContext context, var details, int id, var points, var graph) {
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
              onPressed: () async {
                /* Calcular o peso das dinstâncias com base na diferença das coordenadas */
                SharedPreferences prefs = await SharedPreferences.getInstance();

                int prev = (prefs.getInt('prev') ?? 0);
                //print(prev);
                int peso = ((details.localPosition.dx - points[prev]["x"])
                            .abs() +
                        (details.localPosition.dy - points[prev]["y"]).abs())
                    .round();
                Map<String, dynamic> json = {
                  "id": id,
                  "x": details.localPosition.dx,
                  "y": details.localPosition.dy,
                  /*Sempre existirá ao menos um vizinho, que é o ponto anterior*/
                  "vizinhos": {prev++: peso},
                  "type": type,
                  "name": name
                };
                //print(prev);

                /*O ponto anterior a este deve conter o novo ponto */
                points[prev - 1]["vizinhos"].putIfAbsent(id, () => peso);
                graph[prev - 1] = points[prev - 1]["vizinhos"];

                graph.putIfAbsent(id, () => json["vizinhos"]);
                points.add(json);

                await prefs.setInt('prev', id);
                //print(points);
                //print(graph);

                //List<String> myList = (prefs.getStringList('tracker') ?? []);
                //List<int> myOriginaList =
                //    myList.map((i) => int.parse(i)).toList();
                //print('Your list  $myOriginaList');

                //int usuarioPos = (prefs.getInt('pos') ?? 0);

                //print('Usuario pos $usuarioPos');

                Navigator.pop(context);
              },
              child: const Text("Adicionar")),
        ],
      );
    },
  );
}
