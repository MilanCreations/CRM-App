// To parse this JSON data, do
//
//     final getLeadDetailsModel = getLeadDetailsModelFromJson(jsonString);

import 'dart:convert';

GetLeadDetailsModel getLeadDetailsModelFromJson(String str) => GetLeadDetailsModel.fromJson(json.decode(str));

String getLeadDetailsModelToJson(GetLeadDetailsModel data) => json.encode(data.toJson());

class GetLeadDetailsModel {
    String status;
    Data data;

    GetLeadDetailsModel({
        required this.status,
        required this.data,
    });

    factory GetLeadDetailsModel.fromJson(Map<String, dynamic> json) => GetLeadDetailsModel(
        status: json["status"],
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": data.toJson(),
    };
}

class Data {
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
    String source;
    String queryType;
    dynamic conversionTypeId;
    int leadCreator;
    String leadCreatorName;

    Data({
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
        required this.leadCreatorName,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        name: json["name"],
        phone: json["phone"],
        email: json["email"],
        address: json["address"],
        visitTime: DateTime.parse(json["visit_time"]),
        remark: json["remark"],
        branchName: json["branch_name"],
        branchId: json["branch_id"],
        phoneVerified: json["phone_verified"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        source: json["source"],
        queryType: json["query_type"],
        conversionTypeId: json["conversion_type_id"],
        leadCreator: json["lead_creator"],
        leadCreatorName: json["lead_creator_name"],
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
        "lead_creator_name": leadCreatorName,
    };
}
