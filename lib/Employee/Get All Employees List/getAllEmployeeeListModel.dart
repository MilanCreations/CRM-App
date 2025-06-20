// To parse this JSON data, do
//
//     final getAllEmployeesModel = getAllEmployeesModelFromJson(jsonString);

import 'dart:convert';

GetAllEmployeesModel getAllEmployeesModelFromJson(String str) => GetAllEmployeesModel.fromJson(json.decode(str));

String getAllEmployeesModelToJson(GetAllEmployeesModel data) => json.encode(data.toJson());

class GetAllEmployeesModel {
    String status;
    List<Result> result;

    GetAllEmployeesModel({
        required this.status,
        required this.result,
    });

    factory GetAllEmployeesModel.fromJson(Map<String, dynamic> json) => GetAllEmployeesModel(
        status: json["status"],
        result: List<Result>.from(json["result"].map((x) => Result.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "result": List<dynamic>.from(result.map((x) => x.toJson())),
    };
}

class Result {
    int id;
    String name;

    Result({
        required this.id,
        required this.name,
    });

    factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
    };
}
