// To parse this JSON data, do
//
//     final getAllEmployeeLeaveModel = getAllEmployeeLeaveModelFromJson(jsonString);

import 'dart:convert';

GetAllEmployeeLeaveModel getAllEmployeeLeaveModelFromJson(String str) => GetAllEmployeeLeaveModel.fromJson(json.decode(str));

String getAllEmployeeLeaveModelToJson(GetAllEmployeeLeaveModel data) => json.encode(data.toJson());

class GetAllEmployeeLeaveModel {
    String status;
    Data data;

    GetAllEmployeeLeaveModel({
        required this.status,
        required this.data,
    });

    factory GetAllEmployeeLeaveModel.fromJson(Map<String, dynamic> json) => GetAllEmployeeLeaveModel(
        status: json["status"],
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": data.toJson(),
    };
}

class Data {
    List<Leaf> leaves;
    Pagination pagination;

    Data({
        required this.leaves,
        required this.pagination,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        leaves: List<Leaf>.from(json["leaves"].map((x) => Leaf.fromJson(x))),
        pagination: Pagination.fromJson(json["pagination"]),
    );

    Map<String, dynamic> toJson() => {
        "leaves": List<dynamic>.from(leaves.map((x) => x.toJson())),
        "pagination": pagination.toJson(),
    };
}

class Leaf {
    int id;
    int employeeId;
    DateTime startDate;
    DateTime endDate;
    String reason;
    String status;
    int? approvedBy;
    int leaveTypeId;
    dynamic rejectionReason;
    DateTime createdAt;
    DateTime updatedAt;
    String duration;
    String employeeName;
    String leaveType;
    String? approvedByName;

    Leaf({
        required this.id,
        required this.employeeId,
        required this.startDate,
        required this.endDate,
        required this.reason,
        required this.status,
        required this.approvedBy,
        required this.leaveTypeId,
        required this.rejectionReason,
        required this.createdAt,
        required this.updatedAt,
        required this.duration,
        required this.employeeName,
        required this.leaveType,
        required this.approvedByName,
    });

    factory Leaf.fromJson(Map<String, dynamic> json) => Leaf(
        id: json["id"],
        employeeId: json["employee_id"],
        startDate: DateTime.parse(json["start_date"]),
        endDate: DateTime.parse(json["end_date"]),
        reason: json["reason"],
        status: json["status"],
        approvedBy: json["approved_by"]?? 0,
        leaveTypeId: json["leave_type_id"],
        rejectionReason: json["rejection_reason"]?? "",
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        duration: json["duration"],
        employeeName: json["employee_name"],
        leaveType: json["leave_type"],
        approvedByName: json["approved_by_name"]?? "",
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "employee_id": employeeId,
        "start_date": startDate.toIso8601String(),
        "end_date": endDate.toIso8601String(),
        "reason": reason,
        "status": status,
        "approved_by": approvedBy,
        "leave_type_id": leaveTypeId,
        "rejection_reason": rejectionReason,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "duration": duration,
        "employee_name": employeeName,
        "leave_type": leaveType,
        "approved_by_name": approvedByName,
    };
}

class Pagination {
    int page;
    int limit;
    int total;
    int totalPages;

    Pagination({
        required this.page,
        required this.limit,
        required this.total,
        required this.totalPages,
    });

    factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        page: json["page"],
        limit: json["limit"],
        total: json["total"],
        totalPages: json["total_pages"],
    );

    Map<String, dynamic> toJson() => {
        "page": page,
        "limit": limit,
        "total": total,
        "total_pages": totalPages,
    };
}
