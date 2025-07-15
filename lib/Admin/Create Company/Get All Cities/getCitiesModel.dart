// To parse this JSON data, do
//
//     final getAllCitiesModel = getAllCitiesModelFromJson(jsonString);

import 'dart:convert';

GetAllCitiesModel getAllCitiesModelFromJson(String str) =>
    GetAllCitiesModel.fromJson(json.decode(str));

String getAllCitiesModelToJson(GetAllCitiesModel data) =>
    json.encode(data.toJson());

class GetAllCitiesModel {
  bool success;
  List<Datum> data;

  GetAllCitiesModel({required this.success, required this.data});

  factory GetAllCitiesModel.fromJson(Map<String, dynamic> json) =>
      GetAllCitiesModel(
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
  int stateId;
  bool isActive;
  DateTime createdAt;
  DateTime updatedAt;

  Datum({
    required this.id,
    required this.name,
    required this.stateId,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    name: json["name"],
    stateId: json["state_id"],
    isActive: json["is_active"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "state_id": stateId,
    "is_active": isActive,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
