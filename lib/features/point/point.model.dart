import 'package:mvp_proex/app/app.constant.dart';

class PointModel {
  late String uuid;
  late int id;
  late String name;
  late String description;
  late double x;
  late double y;
  late int floor;
  late bool breakpoint;
  late Map<String, String> neighbor;
  late TypePoint type;
  late String mapId;

  PointModel();

  PointModel.fromJson(Map<String, dynamic> json) {
    uuid = json["id"] ?? "";
    name = json["name"];
    description = json["description"];
    x = json["x"];
    y = json["y"];
    floor = json["floor"];
    breakpoint = json["breakpoint"];
    neighbor = json["neighbor"]; //!
    mapId = json["map_id"];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = <String, dynamic>{}; // Map<String, dynamic>()
    json["id"] = uuid;
    json["name"] = name;
    json["description"] = description;
    json["x"] = x.toString();
    json["y"] = y.toString();
    json["floor"] = floor.toString();
    json["breakpoint"] = breakpoint.toString();
    json["neighbor"] = neighbor;
    json["map_id"] = mapId;
    return json;
  }
}
