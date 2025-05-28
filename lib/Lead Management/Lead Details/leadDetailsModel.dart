// To parse this JSON data, do
//
//     final leadDetailsModel = leadDetailsModelFromJson(jsonString);

import 'dart:convert';

LeadDetailsModel leadDetailsModelFromJson(String str) => LeadDetailsModel.fromJson(json.decode(str));

String leadDetailsModelToJson(LeadDetailsModel data) => json.encode(data.toJson());

class LeadDetailsModel {
    String status;
    List<Result> result;
    int total;
    String filterCount;

    LeadDetailsModel({
        required this.status,
        required this.result,
        required this.total,
        required this.filterCount,
    });

    factory LeadDetailsModel.fromJson(Map<String, dynamic> json) => LeadDetailsModel(
        status: json["status"],
        result: List<Result>.from(json["result"].map((x) => Result.fromJson(x))),
        total: json["total"],
        filterCount: json["filterCount"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "result": List<dynamic>.from(result.map((x) => x.toJson())),
        "total": total,
        "filterCount": filterCount,
    };
}

class Result {
    int id;
    String name;
    DateTime visitTime;
    String purpose;
    String status;
    String remark;
    dynamic followupDate;
    DateTime updatedAt;
    int assignId;
    String employeeName;
    String email;
    String companyName;

    Result({
        required this.id,
        required this.name,
        required this.visitTime,
        required this.purpose,
        required this.status,
        required this.remark,
        required this.followupDate,
        required this.updatedAt,
        required this.assignId,
        required this.employeeName,
        required this.email,
        required this.companyName,
    });

    factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        name: json["name"],
        visitTime: DateTime.parse(json["visit_time"]),
        purpose: json["purpose"],
        status: json["status"],
        remark: json["remark"],
        followupDate: json["followup_date"],
        updatedAt: DateTime.parse(json["updated_at"]),
        assignId: json["assign_id"],
        employeeName: json["employee_name"],
        email: json["email"],
        companyName: json["companyName"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "visit_time": visitTime.toIso8601String(),
        "purpose": purpose,
        "status": status,
        "remark": remark,
        "followup_date": followupDate,
        "updated_at": updatedAt.toIso8601String(),
        "assign_id": assignId,
        "employee_name": employeeName,
        "email": email,
        "companyName": companyName,
    };
}
