// To parse this JSON data, do
//
//     final companyAdminDashboardModel = companyAdminDashboardModelFromJson(jsonString);

import 'dart:convert';

CompanyAdminDashboardModel companyAdminDashboardModelFromJson(String str) =>
    CompanyAdminDashboardModel.fromJson(json.decode(str));

String companyAdminDashboardModelToJson(CompanyAdminDashboardModel data) =>
    json.encode(data.toJson());

class CompanyAdminDashboardModel {
  String satus;
  String message;
  Data data;

  CompanyAdminDashboardModel({
    required this.satus,
    required this.message,
    required this.data,
  });

  factory CompanyAdminDashboardModel.fromJson(Map<String, dynamic> json) =>
      CompanyAdminDashboardModel(
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
  int todayAttendanceCount;
  int todayLeaves;
  int pendingLeaves;
  int approvedLeaves;
  int totalEmployees;

  Data({
    required this.todayAttendanceCount,
    required this.todayLeaves,
    required this.pendingLeaves,
    required this.approvedLeaves,
    required this.totalEmployees,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    todayAttendanceCount: json["todayAttendanceCount"],
    todayLeaves: json["todayLeaves"],
    pendingLeaves: json["pendingLeaves"],
    approvedLeaves: json["approvedLeaves"],
    totalEmployees: json["totalEmployees"],
  );

  Map<String, dynamic> toJson() => {
    "todayAttendanceCount": todayAttendanceCount,
    "todayLeaves": todayLeaves,
    "pendingLeaves": pendingLeaves,
    "approvedLeaves": approvedLeaves,
    "totalEmployees": totalEmployees,
  };
}
