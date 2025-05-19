// To parse this JSON data, do
//
//     final getAllCompaniesModel = getAllCompaniesModelFromJson(jsonString);

import 'dart:convert';

GetAllCompaniesModel getAllCompaniesModelFromJson(String str) => GetAllCompaniesModel.fromJson(json.decode(str));

String getAllCompaniesModelToJson(GetAllCompaniesModel data) => json.encode(data.toJson());

class GetAllCompaniesModel {
    String status;
    List<Result> result;

    GetAllCompaniesModel({
        required this.status,
        required this.result,
    });

    factory GetAllCompaniesModel.fromJson(Map<String, dynamic> json) => GetAllCompaniesModel(
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
    String companyName;

    Result({
        required this.id,
        required this.companyName,
    });

    factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        companyName: json["companyName"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "companyName": companyName,
    };
}
