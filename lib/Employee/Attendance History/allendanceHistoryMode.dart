import 'dart:convert';

AttendanceHistoryModel attendanceHistoryModelFromJson(String str) =>
    AttendanceHistoryModel.fromJson(json.decode(str));

String attendanceHistoryModelToJson(AttendanceHistoryModel data) =>
    json.encode(data.toJson());

class AttendanceHistoryModel {
  String status;
  Data data;

  AttendanceHistoryModel({required this.status, required this.data});

  factory AttendanceHistoryModel.fromJson(Map<String, dynamic> json) =>
      AttendanceHistoryModel(
        status: json["status"] as String,
        data: Data.fromJson(json["data"] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {"status": status, "data": data.toJson()};
}

class Data {
  List<Attendance> attendance;
  Pagination pagination;

  Data({required this.attendance, required this.pagination});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    attendance: List<Attendance>.from(
      (json["attendance"] as List<dynamic>).map(
        (x) => Attendance.fromJson(x as Map<String, dynamic>),
      ),
    ),
    pagination: Pagination.fromJson(json["pagination"] as Map<String, dynamic>),
  );

  Map<String, dynamic> toJson() => {
    "attendance": attendance.map((x) => x.toJson()).toList(),
    "pagination": pagination.toJson(),
  };
}

class Attendance {
  int id;
  int employeeId;
  DateTime date;
  DateTime? checkIn;
  DateTime? checkOut;
  DateTime? breakStart;
  DateTime? breakEnd;
  bool isLate;
  bool leftEarly;
  String? notes;
  String? shiftStartTime;
  String? shiftEndTime;
  int totalBreakMinutes;
  DateTime createdAt;
  DateTime updatedAt;
  String? latitude;
  String? longitude;
  String? picture;
  int markedBy;
  String status;
  DateTime attendanceDate;
  String name;
  int departmentId;

  Attendance({
    required this.id,
    required this.employeeId,
    required this.date,
    this.checkIn,
    this.checkOut,
    this.breakStart,
    this.breakEnd,
    required this.isLate,
    required this.leftEarly,
    this.notes,
    this.shiftStartTime,
    this.shiftEndTime,
    required this.totalBreakMinutes,
    required this.createdAt,
    required this.updatedAt,
    this.latitude,
    this.longitude,
    this.picture,
    required this.markedBy,
    required this.status,
    required this.attendanceDate,
    required this.name,
    required this.departmentId,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) => Attendance(
    id: json["id"] as int,
    employeeId: json["employee_id"] as int,
    date: DateTime.parse(json["date"] as String),
    checkIn:
        json["check_in"] == null
            ? null
            : DateTime.parse(json["check_in"] as String),
    checkOut:
        json["check_out"] == null
            ? null
            : DateTime.parse(json["check_out"] as String),
    breakStart:
        json["break_start"] == null
            ? null
            : DateTime.parse(json["break_start"] as String),
    breakEnd:
        json["break_end"] == null
            ? null
            : DateTime.parse(json["break_end"] as String),
    isLate: json["is_late"] as bool,
    leftEarly: json["left_early"] as bool,
    notes: json["notes"] as String? ?? "",
    shiftStartTime: json["shift_start_time"] as String? ?? "",
    shiftEndTime: json["shift_end_time"] as String? ?? "",
    totalBreakMinutes: json["total_break_minutes"] as int,
    createdAt: DateTime.parse(json["created_at"] as String),
    updatedAt: DateTime.parse(json["updated_at"] as String),
    latitude: json["latitude"] as String? ?? "",
    longitude: json["longitude"] as String? ?? "",
    picture: json["picture"] as String? ?? "",
    markedBy: json["marked_by"] as int,
    status: json["status"] as String,
    attendanceDate: DateTime.parse(json["attendance_date"] as String),
    name: json["name"] as String,
    departmentId: json["department_id"] as int,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "employee_id": employeeId,
    "date": date.toIso8601String(),
    "check_in": checkIn?.toIso8601String(),
    "check_out": checkOut?.toIso8601String(),
    "break_start": breakStart?.toIso8601String(),
    "break_end": breakEnd?.toIso8601String(),
    "is_late": isLate,
    "left_early": leftEarly,
    "notes": notes,
    "shift_start_time": shiftStartTime,
    "shift_end_time": shiftEndTime,
    "total_break_minutes": totalBreakMinutes,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "latitude": latitude,
    "longitude": longitude,
    "picture": picture,
    "marked_by": markedBy,
    "status": status,
    "attendance_date": attendanceDate.toIso8601String().split('T')[0],
    "name": name,
    "department_id": departmentId,
  };
}

class Pagination {
  int page;
  int limit;
  int total;

  Pagination({required this.page, required this.limit, required this.total});

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
    page: json["page"] as int,
    limit: json["limit"] as int,
    total: json["total"] as int,
  );

  Map<String, dynamic> toJson() => {
    "page": page,
    "limit": limit,
    "total": total,
  };
}
