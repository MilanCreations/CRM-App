// To parse this JSON data, do
//
//     final salaryReportModel = salaryReportModelFromJson(jsonString);

import 'dart:convert';

SalaryReportModel salaryReportModelFromJson(String str) => SalaryReportModel.fromJson(json.decode(str));

String salaryReportModelToJson(SalaryReportModel data) => json.encode(data.toJson());

class SalaryReportModel {
    String status;
    List<Result> result;
    int total;
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
    String name;
    int workingDays;
    int noOfLeavesLeavePaidOrUnpaid;
    int noOfDaysPaid;
    int salary;
    int amountPaid;
    int amountDeducted;
    int leaveBalance;
    String reasonForDeduction;

    Result({
        required this.name,
        required this.workingDays,
        required this.noOfLeavesLeavePaidOrUnpaid,
        required this.noOfDaysPaid,
        required this.salary,
        required this.amountPaid,
        required this.amountDeducted,
        required this.leaveBalance,
        required this.reasonForDeduction,
    });

    factory Result.fromJson(Map<String, dynamic> json) => Result(
        name: json["Name"],
        workingDays: json["Working days"],
        noOfLeavesLeavePaidOrUnpaid: json["No. of leaves Leave Paid or unpaid"],
        noOfDaysPaid: json["No. of days paid"],
        salary: json["Salary"],
        amountPaid: json["Amount paid"],
        amountDeducted: json["Amount deducted"],
        leaveBalance: json["Leave Balance"],
        reasonForDeduction: json["Reason for deduction"],
    );

    Map<String, dynamic> toJson() => {
        "Name": name,
        "Working days": workingDays,
        "No. of leaves Leave Paid or unpaid": noOfLeavesLeavePaidOrUnpaid,
        "No. of days paid": noOfDaysPaid,
        "Salary": salary,
        "Amount paid": amountPaid,
        "Amount deducted": amountDeducted,
        "Leave Balance": leaveBalance,
        "Reason for deduction": reasonForDeduction,
    };
}
