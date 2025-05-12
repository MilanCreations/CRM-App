import 'dart:convert';

LeaveHistoryModel leaveHistoryModelFromJson(String str) =>
    LeaveHistoryModel.fromJson(json.decode(str));

String leaveHistoryModelToJson(LeaveHistoryModel data) =>
    json.encode(data.toJson());

class LeaveHistoryModel {
  dynamic status;
  dynamic data;

  LeaveHistoryModel({
    this.status,
    this.data,
  });

  factory LeaveHistoryModel.fromJson(Map<String, dynamic> json) =>
      LeaveHistoryModel(
        status: json["status"],
        data: json["data"] != null ? Data.fromJson(json["data"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
      };
}

class Data {
  List<Leaf>? leaves;
  dynamic pagination;

  Data({
    this.leaves,
    this.pagination,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        leaves: json["leaves"] != null
            ? List<Leaf>.from(json["leaves"].map((x) => Leaf.fromJson(x)))
            : [],
        pagination: json["pagination"] != null
            ? Pagination.fromJson(json["pagination"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "leaves": leaves?.map((x) => x.toJson()).toList(),
        "pagination": pagination?.toJson(),
      };
}

class Leaf {
  dynamic id;
  dynamic employeeId;
  dynamic startDate;
  dynamic endDate;
  dynamic reason;
  dynamic status;
  dynamic approvedBy;
  dynamic leaveTypeId;
  dynamic rejectionReason;
  dynamic createdAt;
  dynamic updatedAt;
  dynamic duration;
  dynamic employeeName;
  dynamic leaveType;
  dynamic approvedByName;

  Leaf({
    this.id,
    this.employeeId,
    this.startDate,
    this.endDate,
    this.reason,
    this.status,
    this.approvedBy,
    this.leaveTypeId,
    this.rejectionReason,
    this.createdAt,
    this.updatedAt,
    this.duration,
    this.employeeName,
    this.leaveType,
    this.approvedByName,
  });

  factory Leaf.fromJson(Map<String, dynamic> json) => Leaf(
        id: json["id"],
        employeeId: json["employee_id"],
        startDate: _parseDate(json["start_date"]),
        endDate: _parseDate(json["end_date"]),
        reason: json["reason"],
        status: json["status"],
        approvedBy: json["approved_by"],
        leaveTypeId: json["leave_type_id"],
        rejectionReason: json["rejection_reason"],
        createdAt: _parseDate(json["created_at"]),
        updatedAt: _parseDate(json["updated_at"]),
        duration: json["duration"],
        employeeName: json["employee_name"],
        leaveType: json["leave_type"],
        approvedByName: json["approved_by_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "employee_id": employeeId,
        "start_date": _toIso(startDate),
        "end_date": _toIso(endDate),
        "reason": reason,
        "status": status,
        "approved_by": approvedBy,
        "leave_type_id": leaveTypeId,
        "rejection_reason": rejectionReason,
        "created_at": _toIso(createdAt),
        "updated_at": _toIso(updatedAt),
        "duration": duration,
        "employee_name": employeeName,
        "leave_type": leaveType,
        "approved_by_name": approvedByName,
      };

  static DateTime? _parseDate(dynamic value) {
    if (value == null || value == "") return null;
    try {
      return DateTime.parse(value);
    } catch (_) {
      return null;
    }
  }

  static String? _toIso(dynamic value) {
    if (value is DateTime) {
      return value.toIso8601String();
    }
    return null;
  }
}

class Pagination {
  dynamic page;
  dynamic limit;
  dynamic total;
  dynamic totalPages;

  Pagination({
    this.page,
    this.limit,
    this.total,
    this.totalPages,
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
