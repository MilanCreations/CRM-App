// To parse this JSON data, do
//
//     final getAllStatesModel = getAllStatesModelFromJson(jsonString);

import 'dart:convert';

GetAllStatesModel getAllStatesModelFromJson(String str) =>
    GetAllStatesModel.fromJson(json.decode(str));

String getAllStatesModelToJson(GetAllStatesModel data) =>
    json.encode(data.toJson());

class GetAllStatesModel {
  bool success;
  List<Datum> data;

  GetAllStatesModel({required this.success, required this.data});

  factory GetAllStatesModel.fromJson(Map<String, dynamic> json) =>
      GetAllStatesModel(
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
  String code;
  int countryId;
  bool isActive;
  DateTime createdAt;
  DateTime updatedAt;

  Datum({
    required this.id,
    required this.name,
    required this.code,
    required this.countryId,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    name: json["name"],
    code: json["code"] ?? "",
    countryId: json["country_id"],
    isActive: json["is_active"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "code": code,
    "country_id": countryId,
    "is_active": isActive,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
