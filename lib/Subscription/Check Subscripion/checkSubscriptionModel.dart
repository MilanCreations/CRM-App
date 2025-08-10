// To parse this JSON data, do
//
//     final checksubscription = checksubscriptionFromJson(jsonString);

import 'dart:convert';

Checksubscription checksubscriptionFromJson(String str) => Checksubscription.fromJson(json.decode(str));

String checksubscriptionToJson(Checksubscription data) => json.encode(data.toJson());

class Checksubscription {
    String status;
    String message;
    List<Datum> data;

    Checksubscription({
        required this.status,
        required this.message,
        required this.data,
    });

    factory Checksubscription.fromJson(Map<String, dynamic> json) => Checksubscription(
        status: json["status"],
        message: json["message"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Datum {
    int baseEmployees;
    String name;
    String extraEmployeeCost;
    int totalEmployees;
    String amountDue;

    Datum({
        required this.baseEmployees,
        required this.name,
        required this.extraEmployeeCost,
        required this.totalEmployees,
        required this.amountDue,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        baseEmployees: json["base_employees"],
        name: json["name"],
        extraEmployeeCost: json["extra_employee_cost"],
        totalEmployees: json["total_employees"],
        amountDue: json["amount_due"],
    );

    Map<String, dynamic> toJson() => {
        "base_employees": baseEmployees,
        "name": name,
        "extra_employee_cost": extraEmployeeCost,
        "total_employees": totalEmployees,
        "amount_due": amountDue,
    };
}
