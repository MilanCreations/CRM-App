// To parse this JSON data, do
//
//     final leadStatusModel = leadStatusModelFromJson(jsonString);

import 'dart:convert';

LeadStatusModel leadStatusModelFromJson(String str) => LeadStatusModel.fromJson(json.decode(str));

String leadStatusModelToJson(LeadStatusModel data) => json.encode(data.toJson());

class LeadStatusModel {
    List<Status> status;

    LeadStatusModel({
        required this.status,
    });

    factory LeadStatusModel.fromJson(Map<String, dynamic> json) => LeadStatusModel(
        status: List<Status>.from(json["status"].map((x) => Status.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": List<dynamic>.from(status.map((x) => x.toJson())),
    };
}

class Status {
    String name;

    Status({
        required this.name,
    });

    factory Status.fromJson(Map<String, dynamic> json) => Status(
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
    };
}
