// To parse this JSON data, do
//
//     final leaveTypeModel = leaveTypeModelFromJson(jsonString);

import 'dart:convert';

LeaveTypeModel leaveTypeModelFromJson(String str) => LeaveTypeModel.fromJson(json.decode(str));

String leaveTypeModelToJson(LeaveTypeModel data) => json.encode(data.toJson());

class LeaveTypeModel {
    String status;
    List<Datum> data;

    LeaveTypeModel({
        required this.status,
        required this.data,
    });

    factory LeaveTypeModel.fromJson(Map<String, dynamic> json) => LeaveTypeModel(
        status: json["status"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Datum {
    int id;
    String name;

    Datum({
        required this.id,
        required this.name,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
    };
}
