// To parse this JSON data, do
//
//     final allLeadsModel = allLeadsModelFromJson(jsonString);

import 'dart:convert';

AllLeadsModel allLeadsModelFromJson(String str) => AllLeadsModel.fromJson(json.decode(str));

String allLeadsModelToJson(AllLeadsModel data) => json.encode(data.toJson());

class AllLeadsModel {
    String status;
    List<Result> result;
    int total;
    String filterCount;

    AllLeadsModel({
        required this.status,
        required this.result,
        required this.total,
        required this.filterCount,
    });

    factory AllLeadsModel.fromJson(Map<String, dynamic> json) => AllLeadsModel(
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
    String source;
    String queryType;
    dynamic conversionTypeId;
    LeadCreator? leadCreator;
    String totalAssigned;
    List<AssignLead> assignLeads;

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
        this.leadCreator,
        required this.totalAssigned,
        required this.assignLeads,
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
        branchId: json["branch_id"],
        phoneVerified: json["phone_verified"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        source: json["source"],
        queryType: json["query_type"],
        conversionTypeId: json["conversion_type_id"],
        leadCreator: json["lead_creator"] == null ? null : LeadCreator.fromJson(json["lead_creator"]),
        totalAssigned: json["total_assigned"],
        assignLeads: List<AssignLead>.from(json["assign_leads"].map((x) => AssignLead.fromJson(x))),
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
        "lead_creator": leadCreator?.toJson(),
        "total_assigned": totalAssigned,
        "assign_leads": List<dynamic>.from(assignLeads.map((x) => x.toJson())),
    };
}

class AssignLead {
    int id;
    num leadId;
    num companyId;
    num employeeId;
    String status;
    String? employeeRemark;
    bool converted;
    DateTime createdAt;
    DateTime updatedAt;
    dynamic convertedBy;
    String employeeName;
    String email;
    String companyName;

    AssignLead({
        required this.id,
        required this.leadId,
        required this.companyId,
        required this.employeeId,
        required this.status,
        required this.employeeRemark,
        required this.converted,
        required this.createdAt,
        required this.updatedAt,
        required this.convertedBy,
        required this.employeeName,
        required this.email,
        required this.companyName,
    });

    factory AssignLead.fromJson(Map<String, dynamic> json) => AssignLead(
        id: json["id"],
        leadId: json["lead_id"],
        companyId: json["company_id"],
        employeeId: json["employee_id"],
        status: json["status"],
        employeeRemark: json["employee_remark"],
        converted: json["converted"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        convertedBy: json["converted_by"],
        employeeName: json["employee_name"],
        email: json["email"],
        companyName: json["companyName"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "lead_id": leadId,
        "company_id": companyId,
        "employee_id": employeeId,
        "status": status,
        "employee_remark": employeeRemark,
        "converted": converted,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "converted_by": convertedBy,
        "employee_name": employeeName,
        "email": email,
        "companyName": companyName,
    };
}

class LeadCreator {
    String name;

    LeadCreator({
        required this.name,
    });

    factory LeadCreator.fromJson(Map<String, dynamic> json) => LeadCreator(
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
    };
}
