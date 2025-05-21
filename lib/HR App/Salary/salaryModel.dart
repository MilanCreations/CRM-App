// To parse this JSON data, do
//
//     final salaryReportModel = salaryReportModelFromJson(jsonString);

import 'dart:convert';

SalaryReportModel salaryReportModelFromJson(String str) => SalaryReportModel.fromJson(json.decode(str));

String salaryReportModelToJson(SalaryReportModel data) => json.encode(data.toJson());

class SalaryReportModel {
    String status;
    List<Result> result;
    String total;
    int filterCount;
    int page;
    int limit;
    int totalPages;

    SalaryReportModel({
        required this.status,
        required this.result,
        required this.total,
        required this.filterCount,
        required this.page,
        required this.limit,
        required this.totalPages,
    });

    factory SalaryReportModel.fromJson(Map<String, dynamic> json) => SalaryReportModel(
        status: json["status"],
        result: List<Result>.from(json["result"].map((x) => Result.fromJson(x))),
        total: json["total"],
        filterCount: json["filterCount"],
        page: json["page"],
        limit: json["limit"],
        totalPages: json["totalPages"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "result": List<dynamic>.from(result.map((x) => x.toJson())),
        "total": total,
        "filterCount": filterCount,
        "page": page,
        "limit": limit,
        "totalPages": totalPages,
    };
}

class Result {
    int employeeId;
    String name;
    String baseSalary;
    int presentDays;
    int unpaidLeaves;
    int lateArrivals;
    int earlyLeaves;
    dynamic workingHours;
    String deduction;
    String payableSalary;

    Result({
        required this.employeeId,
        required this.name,
        required this.baseSalary,
        required this.presentDays,
        required this.unpaidLeaves,
        required this.lateArrivals,
        required this.earlyLeaves,
        required this.workingHours,
        required this.deduction,
        required this.payableSalary,
    });

    factory Result.fromJson(Map<String, dynamic> json) => Result(
        employeeId: json["EmployeeID"],
        name: json["Name"],
        baseSalary: json["BaseSalary"],
        presentDays: json["PresentDays"],
        unpaidLeaves: json["UnpaidLeaves"],
        lateArrivals: json["LateArrivals"],
        earlyLeaves: json["EarlyLeaves"],
        workingHours: json["WorkingHours"],
        deduction: json["Deduction"],
        payableSalary: json["PayableSalary"],
    );

    Map<String, dynamic> toJson() => {
        "EmployeeID": employeeId,
        "Name": name,
        "BaseSalary": baseSalary,
        "PresentDays": presentDays,
        "UnpaidLeaves": unpaidLeaves,
        "LateArrivals": lateArrivals,
        "EarlyLeaves": earlyLeaves,
        "WorkingHours": workingHours,
        "Deduction": deduction,
        "PayableSalary": payableSalary,
    };
}
