class UserModel {
  late String name;
  late String email;
  late String password;
  late String permission;
  late String id;
  late String token;

  UserModel(
      {this.email = "",
      this.password = "",
      this.name = "",
      this.permission = "NORMAL",
      this.id = "",
      this.token = ""});

  UserModel.fromJson(Map<String, dynamic> json) {
    this.name = json["name"].toString();
    this.email = json["email"].toString();
    this.password = json["password"].toString();
    this.permission = json["permission"].toString();
    this.id = json["id"] ?? '';
    this.token = json["token"] ?? '';
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = new Map<String, dynamic>();
    json["name"] = this.name;
    json["email"] = this.email;
    json["password"] = this.password;
    json["role"] = this.permission;
    return json;
  }
}
