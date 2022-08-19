import 'package:flutter/material.dart';
import 'package:mvp_proex/app/app.constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mvp_proex/features/point/point.model.dart';

Future dialogPointWidget(
  BuildContext context,
  var details,
  int id,
  List<PointModel> points,
  var graph,
) {
  return showDialog(
    context: context,
    builder: (context) {
      TypePoint type = TypePoint.path;
      String name = "Caminho";
      String descricao = "Descrição";
      return AlertDialog(
        title: Text("Adicionar ponto $id"),
        content: Column(
          children: [
            Text(
                "X = ${details.localPosition.dx}\nY = ${details.localPosition.dy}"),
            DropdownButtonFormField(
              value: type,
              items: const [
                DropdownMenuItem(
                  child: Text("Objetivo"),
                  value: TypePoint.goal,
                ),
                DropdownMenuItem(
                  child: Text("Caminho"),
                  value: TypePoint.path,
                ),
              ],
              onChanged: (value) {
                if (value != TypePoint.goal) {
                  name = "Caminho";
                  type = TypePoint.path;
                } else {
                  name = "Objetivo";
                  type = TypePoint.goal;
                }
              },
            ),
            TextFormField(
              initialValue: name,
              decoration: const InputDecoration(
                labelText: "Nome do ponto",
              ),
              onChanged: (value) {
                if (value.isEmpty) {
                  name = "Ponto $id";
                } else {
                  name = value;
                }
              },
            ),
            TextFormField(
              initialValue: descricao,
              decoration: const InputDecoration(
                labelText: "Descrição do ponto",
              ),
              onChanged: (value) {
                if (value.isEmpty) {
                  descricao = "Descrição";
                } else {
                  descricao = value;
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
                /* Calcular o peso das distâncias com base na diferença das coordenadas */
                SharedPreferences prefs = await SharedPreferences.getInstance();

                int prev = (prefs.getInt('prev') ?? 0);
                // print(prev);
                int peso = ((details.localPosition.dx - points[prev].x).abs() +
                        (details.localPosition.dy - points[prev].y).abs())
                    .round();
                PointModel point = PointModel();
                point.id = id;
                point.x = details.localPosition.dx;
                point.y = details.localPosition.dy;
                point.description = descricao;
                point.type = type;
                point.name = name;
                point.neighbor = {"qq string": "qq string"};
                Map<String, dynamic> json = {
                  "id": id,
                  "x": details.localPosition.dx,
                  "y": details.localPosition.dy,
                  "descricao": descricao,
                  /*Sempre existirá ao menos um vizinho, que é o ponto anterior*/
                  "vizinhos": {prev++: peso},
                  "type": type,
                  "name": name
                };
                // print(prev);

                /* O ponto anterior a este deve conter o novo ponto */
                // points[prev - 1].neighbor.putIfAbsent(id, () => peso);
                graph[prev - 1] = points[prev - 1].neighbor;

                graph.putIfAbsent(id, () => json["vizinhos"]);
                points.add(point);

                await prefs.setInt('prev', id);
                // print(points);
                // print(graph);

                // List<String> myList = (prefs.getStringList('tracker') ?? []);
                // List<int> myOriginaList =
                //     myList.map((i) => int.parse(i)).toList();
                // print('Your list  $myOriginaList');

                // int usuarioPos = (prefs.getInt('pos') ?? 0);

                // print('Usuario pos $usuarioPos');

                Navigator.pop(context);
              },
              child: const Text("Adicionar")),
        ],
      );
    },
  );
}
