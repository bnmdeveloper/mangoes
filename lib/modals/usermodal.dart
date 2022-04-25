// To parse this JSON data, do
//
//     final usermodal = usermodalFromJson(jsonString);

import 'dart:convert';

Usermodal usermodalFromJson(String str) => Usermodal.fromJson(json.decode(str));

String usermodalToJson(Usermodal data) => json.encode(data.toJson());

class Usermodal {
  Usermodal({
    required this.body,
    required this.itemCount,
  });

  List<Body> body;
  int itemCount;

  factory Usermodal.fromJson(Map<String, dynamic> json) => Usermodal(
        body: List<Body>.from(json["body"].map((x) => Body.fromJson(x))),
        itemCount: json["itemCount"],
      );

  Map<String, dynamic> toJson() => {
        "body": List<dynamic>.from(body.map((x) => x.toJson())),
        "itemCount": itemCount,
      };
}

class Body {
  Body({
    required this.id,
    required this.name,
    required this.mobile,
    required this.password,
    required this.lastLogin,
  });

  String id;
  String name;
  String mobile;
  String password;
  DateTime lastLogin;

  factory Body.fromJson(Map<String, dynamic> json) => Body(
        id: json["id"],
        name: json["name"],
        mobile: json["mobile"],
        password: json["password"],
        lastLogin: DateTime.parse(json["last_login"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "mobile": mobile,
        "password": password,
        "last_login": lastLogin.toIso8601String(),
      };
}
