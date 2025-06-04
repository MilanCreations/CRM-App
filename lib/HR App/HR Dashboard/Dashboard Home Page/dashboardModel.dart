// To parse this JSON data, do
//
//     final dashboard = dashboardFromJson(jsonString);

import 'dart:convert';

Dashboard dashboardFromJson(String str) => Dashboard.fromJson(json.decode(str));

String dashboardToJson(Dashboard data) => json.encode(data.toJson());

class Dashboard {
    String satus;
    String message;
    Data data;

    Dashboard({
        required this.satus,
        required this.message,
        required this.data,
    });

    factory Dashboard.fromJson(Map<String, dynamic> json) => Dashboard(
        satus: json["satus"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "satus": satus,
        "message": message,
        "data": data.toJson(),
    };
}

class Data {
    int myLeads;
    int todayAttendanceCount;
    int todayLeaves;
    int pendingLeaves;
    int approvedLeaves;

    Data({
        required this.myLeads,
        required this.todayAttendanceCount,
        required this.todayLeaves,
        required this.pendingLeaves,
        required this.approvedLeaves,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        myLeads: json["myLeads"],
        todayAttendanceCount: json["todayAttendanceCount"],
        todayLeaves: json["todayLeaves"],
        pendingLeaves: json["pendingLeaves"],
        approvedLeaves: json["approvedLeaves"],
    );

    Map<String, dynamic> toJson() => {
        "myLeads": myLeads,
        "todayAttendanceCount": todayAttendanceCount,
        "todayLeaves": todayLeaves,
        "pendingLeaves": pendingLeaves,
        "approvedLeaves": approvedLeaves,
    };
}
