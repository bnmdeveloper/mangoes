import 'dart:convert';

Mangovariant mangovariantFromJson(String str) =>
    Mangovariant.fromJson(json.decode(str));

String mangovariantToJson(Mangovariant data) => json.encode(data.toJson());

class Mangovariant {
  Mangovariant({
    required this.body,
    required this.itemCount,
  });

  List<Body> body;
  int itemCount;

  factory Mangovariant.fromJson(Map<String, dynamic> json) => Mangovariant(
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
    required this.mangoName,
    required this.price,
  });

  String id;
  String mangoName;
  String price;

  factory Body.fromJson(Map<String, dynamic> json) => Body(
        id: json["id"],
        mangoName: json["mango_name"],
        price: json["price"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "mango_name": mangoName,
        "price": price,
      };
}
