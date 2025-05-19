// To parse this JSON data, do
//
//     final createLeadModel = createLeadModelFromJson(jsonString);

import 'dart:convert';

CreateLeadModel createLeadModelFromJson(String str) => CreateLeadModel.fromJson(json.decode(str));

String createLeadModelToJson(CreateLeadModel data) => json.encode(data.toJson());

class CreateLeadModel {
    String status;
    String message;

    CreateLeadModel({
        required this.status,
        required this.message,
    });

    factory CreateLeadModel.fromJson(Map<String, dynamic> json) => CreateLeadModel(
        status: json["status"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
    };
}
