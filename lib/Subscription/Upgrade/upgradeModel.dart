// To parse this JSON data, do
//
//     final upgeademodel = upgeademodelFromJson(jsonString);

import 'dart:convert';

Upgeademodel upgeademodelFromJson(String str) => Upgeademodel.fromJson(json.decode(str));

String upgeademodelToJson(Upgeademodel data) => json.encode(data.toJson());

class Upgeademodel {
    bool success;
    String message;
    Data data;

    Upgeademodel({
        required this.success,
        required this.message,
        required this.data,
    });

    factory Upgeademodel.fromJson(Map<String, dynamic> json) => Upgeademodel(
        success: json["success"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data.toJson(),
    };
}

class Data {
    int extraEmployees;
    int baseAmount;
    int gstAmount;
    int totalAmount;
    UsageId usageId;

    Data({
        required this.extraEmployees,
        required this.baseAmount,
        required this.gstAmount,
        required this.totalAmount,
        required this.usageId,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        extraEmployees: json["extraEmployees"],
        baseAmount: json["baseAmount"],
        gstAmount: json["gstAmount"],
        totalAmount: json["totalAmount"],
        usageId: UsageId.fromJson(json["usageId"]),
    );

    Map<String, dynamic> toJson() => {
        "extraEmployees": extraEmployees,
        "baseAmount": baseAmount,
        "gstAmount": gstAmount,
        "totalAmount": totalAmount,
        "usageId": usageId.toJson(),
    };
}

class UsageId {
    int id;

    UsageId({
        required this.id,
    });

    factory UsageId.fromJson(Map<String, dynamic> json) => UsageId(
        id: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
    };
}
