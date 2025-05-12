// To parse this JSON data, do
//
//     final breakEndModel = breakEndModelFromJson(jsonString);

import 'dart:convert';

BreakEndModel breakEndModelFromJson(String str) => BreakEndModel.fromJson(json.decode(str));

String breakEndModelToJson(BreakEndModel data) => json.encode(data.toJson());

class BreakEndModel {
    String status;
    Data data;

    BreakEndModel({
        required this.status,
        required this.data,
    });

    factory BreakEndModel.fromJson(Map<String, dynamic> json) => BreakEndModel(
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
    DateTime date;
    DateTime checkIn;
    dynamic checkOut;
    DateTime breakStart;
    DateTime breakEnd;
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

    Data({
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

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        employeeId: json["employee_id"],
        date: DateTime.parse(json["date"]),
        checkIn: DateTime.parse(json["check_in"]),
        checkOut: json["check_out"]?? "",
        breakStart: DateTime.parse(json["break_start"]),
        breakEnd: DateTime.parse(json["break_end"]),
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
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "employee_id": employeeId,
        "date": date.toIso8601String(),
        "check_in": checkIn.toIso8601String(),
        "check_out": checkOut,
        "break_start": breakStart.toIso8601String(),
        "break_end": breakEnd.toIso8601String(),
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
