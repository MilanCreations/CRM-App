// To parse this JSON data, do
//
//     final applyLeaveModel = applyLeaveModelFromJson(jsonString);

import 'dart:convert';

ApplyLeaveModel applyLeaveModelFromJson(String str) => ApplyLeaveModel.fromJson(json.decode(str));

String applyLeaveModelToJson(ApplyLeaveModel data) => json.encode(data.toJson());

class ApplyLeaveModel {
    String status;
    Data data;

    ApplyLeaveModel({
        required this.status,
        required this.data,
    });

    factory ApplyLeaveModel.fromJson(Map<String, dynamic> json) => ApplyLeaveModel(
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
    int employeeId;
    DateTime startDate;
    DateTime endDate;
    String reason;
    String status;
    dynamic approvedBy;
    int leaveTypeId;
    dynamic rejectionReason;
    DateTime createdAt;
    DateTime updatedAt;

    Data({
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
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        employeeId: json["employee_id"],
        startDate: DateTime.parse(json["start_date"]),
        endDate: DateTime.parse(json["end_date"]),
        reason: json["reason"],
        status: json["status"],
        approvedBy: json["approved_by"]?? "",
        leaveTypeId: json["leave_type_id"],
        rejectionReason: json["rejection_reason"]?? "",
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
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
    };
}
