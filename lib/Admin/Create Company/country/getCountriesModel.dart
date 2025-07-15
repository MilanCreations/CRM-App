// To parse this JSON data, do
//
//     final getAllCountriesModel = getAllCountriesModelFromJson(jsonString);

import 'dart:convert';

GetAllCountriesModel getAllCountriesModelFromJson(String str) =>
    GetAllCountriesModel.fromJson(json.decode(str));

String getAllCountriesModelToJson(GetAllCountriesModel data) =>
    json.encode(data.toJson());

class GetAllCountriesModel {
  bool success;
  List<Datum> data;

  GetAllCountriesModel({required this.success, required this.data});

  factory GetAllCountriesModel.fromJson(Map<String, dynamic> json) =>
      GetAllCountriesModel(
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
  String phoneCode;
  bool isActive;
  DateTime createdAt;
  DateTime updatedAt;

  Datum({
    required this.id,
    required this.name,
    required this.code,
    required this.phoneCode,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    name: json["name"],
    code: json["code"],
    phoneCode: json["phone_code"],
    isActive: json["is_active"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "code": code,
    "phone_code": phoneCode,
    "is_active": isActive,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
