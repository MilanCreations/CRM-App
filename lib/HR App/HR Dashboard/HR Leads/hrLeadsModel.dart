// To parse this JSON data, do
//
//     final hrLeadsModel = hrLeadsModelFromJson(jsonString);

import 'dart:convert';

HrLeadsModel hrLeadsModelFromJson(String str) => HrLeadsModel.fromJson(json.decode(str));

String hrLeadsModelToJson(HrLeadsModel data) => json.encode(data.toJson());

class HrLeadsModel {
    String status;
    List<Result> result;
    int total;
    String filterCount;

    HrLeadsModel({
        required this.status,
        required this.result,
        required this.total,
        required this.filterCount,
    });

    factory HrLeadsModel.fromJson(Map<String, dynamic> json) => HrLeadsModel(
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
    String phone;
    String email;
    String address;
    DateTime visitTime;
    String remark;
    String branchName;
    dynamic branchId;
    bool phoneVerified;
    DateTime createdAt;
    DateTime updatedAt;
    String? source;
    String? queryType;
    dynamic conversionTypeId;
    String? leadCreator;
    String status;
    String? employeeRemark;
    int assignId;
    String employeeName;
    String companyName;

    Result({
        required this.id,
        required this.name,
        required this.phone,
        required this.email,
        required this.address,
        required this.visitTime,
        required this.remark,
        required this.branchName,
        required this.branchId,
        required this.phoneVerified,
        required this.createdAt,
        required this.updatedAt,
        required this.source,
        required this.queryType,
        required this.conversionTypeId,
        required this.leadCreator,
        required this.status,
        required this.employeeRemark,
        required this.assignId,
        required this.employeeName,
        required this.companyName,
    });

    factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        name: json["name"],
        phone: json["phone"],
        email: json["email"],
        address: json["address"],
        visitTime: DateTime.parse(json["visit_time"]),
        remark: json["remark"],
        branchName: json["branch_name"],
        branchId: json["branch_id"]?? 0,
        phoneVerified: json["phone_verified"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        source: json["source"],
        queryType: json["query_type"],
        conversionTypeId: json["conversion_type_id"]?? 0,
        leadCreator: json["lead_creator"]?? "",
        status: json["status"],
        employeeRemark: json["employee_remark"]?? "",
        assignId: json["assign_id"],
        employeeName: json["employee_name"],
        companyName: json["companyName"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "phone": phone,
        "email": email,
        "address": address,
        "visit_time": visitTime.toIso8601String(),
        "remark": remark,
        "branch_name": branchName,
        "branch_id": branchId,
        "phone_verified": phoneVerified,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "source": source,
        "query_type": queryType,
        "conversion_type_id": conversionTypeId,
        "lead_creator": leadCreator,
        "status": status,
        "employee_remark": employeeRemark,
        "assign_id": assignId,
        "employee_name": employeeName,
        "companyName": companyName,
    };
}
