// To parse this JSON data, do
//
//     final companytypeModel = companytypeModelFromJson(jsonString);

import 'dart:convert';

CompanytypeModel companytypeModelFromJson(String str) =>
    CompanytypeModel.fromJson(json.decode(str));

String companytypeModelToJson(CompanytypeModel data) =>
    json.encode(data.toJson());

class CompanytypeModel {
  bool success;
  List<Datum> data;

  CompanytypeModel({required this.success, required this.data});

  factory CompanytypeModel.fromJson(Map<String, dynamic> json) =>
      CompanytypeModel(
        success: json["success"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  int id;
  String name;
  String description;
  bool isActive;
  DateTime createdAt;
  DateTime updatedAt;

  Datum({
    required this.id,
    required this.name,
    required this.description,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    isActive: json["is_active"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "is_active": isActive,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
