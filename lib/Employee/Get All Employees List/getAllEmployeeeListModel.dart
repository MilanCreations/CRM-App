// To parse this JSON data, do
//
//     final getAllEmployeesModel = getAllEmployeesModelFromJson(jsonString);

import 'dart:convert';

GetAllEmployeesModel getAllEmployeesModelFromJson(String str) => GetAllEmployeesModel.fromJson(json.decode(str));

String getAllEmployeesModelToJson(GetAllEmployeesModel data) => json.encode(data.toJson());

class GetAllEmployeesModel {
    String status;
    List<Resultemp> result;

    GetAllEmployeesModel({
        required this.status,
        required this.result,
    });

    factory GetAllEmployeesModel.fromJson(Map<String, dynamic> json) => GetAllEmployeesModel(
        status: json["status"],
        result: List<Resultemp>.from(json["result"].map((x) => Resultemp.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "result": List<dynamic>.from(result.map((x) => x.toJson())),
    };
}

class Resultemp {
    int id;
    String name;

    Resultemp({
        required this.id,
        required this.name,
    });

    factory Resultemp.fromJson(Map<String, dynamic> json) => Resultemp(
        id: json["id"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
    };
}
