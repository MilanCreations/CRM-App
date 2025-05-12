// To parse this JSON data, do
//
//     final attendanceHistoryModel = attendanceHistoryModelFromJson(jsonString);

import 'dart:convert';

AttendanceHistoryModel attendanceHistoryModelFromJson(String str) => AttendanceHistoryModel.fromJson(json.decode(str));

String attendanceHistoryModelToJson(AttendanceHistoryModel data) => json.encode(data.toJson());

class AttendanceHistoryModel {
    String status;
    Data data;

    AttendanceHistoryModel({
        required this.status,
        required this.data,
    });

    factory AttendanceHistoryModel.fromJson(Map<String, dynamic> json) => AttendanceHistoryModel(
        status: json["status"],
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": data.toJson(),
    };
}

class Data {
    List<Attendance> attendance;
    Pagination pagination;

    Data({
        required this.attendance,
        required this.pagination,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        attendance: List<Attendance>.from(json["attendance"].map((x) => Attendance.fromJson(x))),
        pagination: Pagination.fromJson(json["pagination"]),
    );

    Map<String, dynamic> toJson() => {
        "attendance": List<dynamic>.from(attendance.map((x) => x.toJson())),
        "pagination": pagination.toJson(),
    };
}

class Attendance {
    int id;
    int employeeId;
    DateTime date;
    DateTime checkIn;
    DateTime checkOut;
    DateTime? breakStart;
    DateTime? breakEnd;
    bool isLate;
    bool leftEarly;
    dynamic notes;
    dynamic shiftStartTime;
    dynamic shiftEndTime;
    int totalBreakMinutes;
    DateTime createdAt;
    DateTime updatedAt;
    String latitude;
    String longitude;
    String picture;
    int markedBy;
    String status;
    DateTime attendanceDate;
    String name;
    int departmentId;

    Attendance({
        required this.id,
        required this.employeeId,
        required this.date,
        required this.checkIn,
        required this.checkOut,
        required this.breakStart,
        required this.breakEnd,
        required this.isLate,
        required this.leftEarly,
        required this.notes,
        required this.shiftStartTime,
        required this.shiftEndTime,
        required this.totalBreakMinutes,
        required this.createdAt,
        required this.updatedAt,
        required this.latitude,
        required this.longitude,
        required this.picture,
        required this.markedBy,
        required this.status,
        required this.attendanceDate,
        required this.name,
        required this.departmentId,
    });

    factory Attendance.fromJson(Map<String, dynamic> json) => Attendance(
        id: json["id"],
        employeeId: json["employee_id"],
        date: DateTime.parse(json["date"]),
        checkIn: DateTime.parse(json["check_in"]),
        checkOut: DateTime.parse(json["check_out"]?? "2025-04-30T05:07:27.158Z"),
        breakStart: json["break_start"] == null ? null : DateTime.parse(json["break_start"]),
        breakEnd: json["break_end"] == null ? null : DateTime.parse(json["break_end"]),
        isLate: json["is_late"],
        leftEarly: json["left_early"],
        notes: json["notes"]?? "",
        shiftStartTime: json["shift_start_time"]?? "",
        shiftEndTime: json["shift_end_time"]?? "",
        totalBreakMinutes: json["total_break_minutes"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        latitude: json["latitude"],
        longitude: json["longitude"],
        picture: json["picture"],
        markedBy: json["marked_by"],
        status: json["status"],
        attendanceDate: DateTime.parse(json["attendance_date"]),
        name: json["name"],
        departmentId: json["department_id"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "employee_id": employeeId,
        "date": date.toIso8601String(),
        "check_in": checkIn.toIso8601String(),
        "check_out": checkOut.toIso8601String(),
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
        "attendance_date": "${attendanceDate.year.toString().padLeft(4, '0')}-${attendanceDate.month.toString().padLeft(2, '0')}-${attendanceDate.day.toString().padLeft(2, '0')}",
        "name": name,
        "department_id": departmentId,
    };
}

class Pagination {
    int page;
    int limit;
    int total;

    Pagination({
        required this.page,
        required this.limit,
        required this.total,
    });

    factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        page: json["page"],
        limit: json["limit"],
        total: json["total"],
    );

    Map<String, dynamic> toJson() => {
        "page": page,
        "limit": limit,
        "total": total,
    };
}
