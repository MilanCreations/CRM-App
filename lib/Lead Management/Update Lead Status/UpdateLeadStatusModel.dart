// To parse this JSON data, do
//
//     final updateleadStatusModel = updateleadStatusModelFromJson(jsonString);

import 'dart:convert';

UpdateleadStatusModel updateleadStatusModelFromJson(String str) => UpdateleadStatusModel.fromJson(json.decode(str));

String updateleadStatusModelToJson(UpdateleadStatusModel data) => json.encode(data.toJson());

class UpdateleadStatusModel {
    String status;
    String message;

    UpdateleadStatusModel({
        required this.status,
        required this.message,
    });

    factory UpdateleadStatusModel.fromJson(Map<String, dynamic> json) => UpdateleadStatusModel(
        status: json["status"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
    };
}
