// To parse this JSON data, do
//
//     final checkinStatus = checkinStatusFromJson(jsonString);

import 'dart:convert';

CheckinStatus checkinStatusFromJson(String str) => CheckinStatus.fromJson(json.decode(str));

String checkinStatusToJson(CheckinStatus data) => json.encode(data.toJson());

class CheckinStatus {
    String status;
    Data data;

    CheckinStatus({
        required this.status,
        required this.data,
    });

    factory CheckinStatus.fromJson(Map<String, dynamic> json) => CheckinStatus(
        status: json["status"],
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": data.toJson(),
    };
}

class Data {
    Attendance attendance;
    DateTime currentTime;

    Data({
        required this.attendance,
        required this.currentTime,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        attendance: Attendance.fromJson(json["attendance"]),
        currentTime: DateTime.parse(json["currentTime"]),
    );

    Map<String, dynamic> toJson() => {
        "attendance": attendance.toJson(),
        "currentTime": currentTime.toIso8601String(),
    };
}

class Attendance {
    int id;
    int employeeId;
    DateTime date;
    DateTime checkIn;
    dynamic checkOut;
    dynamic breakStart;
    dynamic breakEnd;
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
    });

    factory Attendance.fromJson(Map<String, dynamic> json) => Attendance(
        id: json["id"],
        employeeId: json["employee_id"]?? 0,
        date: DateTime.parse(json["date"]?? ""),
        checkIn: DateTime.parse(json["check_in"]?? ""),
        checkOut: json["check_out"]?? "checkout",
        breakStart: json["break_start"]?? "",
        breakEnd: json["break_end"]?? "",
        isLate: json["is_late"]?? 0,
        leftEarly: json["left_early"]?? 0,
        notes: json["notes"]?? "",
        shiftStartTime: json["shift_start_time"]?? "",
        shiftEndTime: json["shift_end_time"]?? "",
        totalBreakMinutes: json["total_break_minutes"]?? 0,
        createdAt: DateTime.parse(json["created_at"]?? ""),
        updatedAt: DateTime.parse(json["updated_at"]?? ""),
        latitude: json["latitude"]??"",
        longitude: json["longitude"]??"",
        picture: json["picture"]??"",
        markedBy: json["marked_by"]??"",
        status: json["status"]??"",
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "employee_id": employeeId,
        "date": date.toIso8601String(),
        "check_in": checkIn.toIso8601String(),
        "check_out": checkOut,
        "break_start": breakStart,
        "break_end": breakEnd,
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
    };
}
