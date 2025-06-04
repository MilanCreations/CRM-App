// To parse this JSON data, do
//
//     final todayLeaveModel = todayLeaveModelFromJson(jsonString);

import 'dart:convert';

TodayLeaveModel todayLeaveModelFromJson(String str) => TodayLeaveModel.fromJson(json.decode(str));

String todayLeaveModelToJson(TodayLeaveModel data) => json.encode(data.toJson());

class TodayLeaveModel {
    String status;
    Data data;

    TodayLeaveModel({
        required this.status,
        required this.data,
    });

    factory TodayLeaveModel.fromJson(Map<String, dynamic> json) => TodayLeaveModel(
        status: json["status"],
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": data.toJson(),
    };
}

class Data {
    List<TodayLeaf> leaves;
    Pagination pagination;

    Data({
        required this.leaves,
        required this.pagination,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        leaves: List<TodayLeaf>.from(json["leaves"].map((x) => TodayLeaf.fromJson(x))),
        pagination: Pagination.fromJson(json["pagination"]),
    );

    Map<String, dynamic> toJson() => {
        "leaves": List<dynamic>.from(leaves.map((x) => x.toJson())),
        "pagination": pagination.toJson(),
    };
}

class TodayLeaf {
  final int id;
  final int employeeId;
  final DateTime startDate;
  final DateTime endDate;
  final String reason;
  final String status;
  final int? approvedBy; // nullable
  final int? leaveTypeId; // nullable
  final String? rejectionReason; // nullable
  final DateTime createdAt;
  final DateTime updatedAt;
  final String duration;
  final String employeeName;
  final String? leaveType; // may be nullable
  final String? approvedByName; // nullable

  TodayLeaf({
    required this.id,
    required this.employeeId,
    required this.startDate,
    required this.endDate,
    required this.reason,
    required this.status,
    this.approvedBy,
    this.leaveTypeId,
    this.rejectionReason,
    required this.createdAt,
    required this.updatedAt,
    required this.duration,
    required this.employeeName,
    this.leaveType,
    this.approvedByName,
  });

  factory TodayLeaf.fromJson(Map<String, dynamic> json) => TodayLeaf(
        id: json["id"] ?? 0,
        employeeId: json["employee_id"] ?? 0,
        startDate: DateTime.tryParse(json["start_date"] ?? "") ?? DateTime.now(),
        endDate: DateTime.tryParse(json["end_date"] ?? "") ?? DateTime.now(),
        reason: json["reason"] ?? '',
        status: json["status"] ?? '',
        approvedBy: json["approved_by"],
        leaveTypeId: json["leave_type_id"],
        rejectionReason: json["rejection_reason"],
        createdAt: DateTime.tryParse(json["created_at"] ?? "") ?? DateTime.now(),
        updatedAt: DateTime.tryParse(json["updated_at"] ?? "") ?? DateTime.now(),
        duration: json["duration"] ?? '',
        employeeName: json["employee_name"] ?? '',
        leaveType: json["leave_type"],
        approvedByName: json["approved_by_name"],
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
