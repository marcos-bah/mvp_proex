class OrganizationModel {
  late String id;
  late String name;
  late String description;
  late String cep;
  late String state;
  late String city;
  late String neighborhood;
  late String street;
  late String number;

  OrganizationModel();

  OrganizationModel.fromJson(Map<String, dynamic> json) {
    this.id = json["id"] ?? "";
    this.name = json["name"];
    this.description = json["description"];
    this.cep = json["cep"];
    this.state = json["state"];
    this.city = json["city"];
    this.neighborhood = json["neighborhood"];
    this.street = json["street"];
    this.number = json["number"];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = new Map<String, dynamic>();
    json["name"] = this.name;
    json["description"] = this.description;
    json["cep"] = this.cep;
    json["state"] = this.state;
    json["city"] = this.city;
    json["neighborhood"] = this.neighborhood;
    json["street"] = this.street;
    json["number"] = this.number;
    return json;
  }
}
