// To parse this JSON data, do
//
//     final addEmployeeModel = addEmployeeModelFromJson(jsonString);

import 'dart:convert';

AddEmployeeModel addEmployeeModelFromJson(String str) => AddEmployeeModel.fromJson(json.decode(str));

String addEmployeeModelToJson(AddEmployeeModel data) => json.encode(data.toJson());

class AddEmployeeModel {
    bool success;
    String message;
    Data data;

    AddEmployeeModel({
        required this.success,
        required this.message,
        required this.data,
    });

    factory AddEmployeeModel.fromJson(Map<String, dynamic> json) => AddEmployeeModel(
        success: json["success"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data.toJson(),
    };
}

class Data {
    int id;
    String email;
    dynamic phone;
    String name;
    String salary;
    int departmentId;
    int designationId;
    dynamic companyId;
    String token;
    DateTime tokenExpiry;
    String status;
    DateTime createdAt;
    DateTime updatedAt;

    Data({
        required this.id,
        required this.email,
        required this.phone,
        required this.name,
        required this.salary,
        required this.departmentId,
        required this.designationId,
        required this.companyId,
        required this.token,
        required this.tokenExpiry,
        required this.status,
        required this.createdAt,
        required this.updatedAt,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        email: json["email"],
        phone: json["phone"],
        name: json["name"],
        salary: json["salary"],
        departmentId: json["department_id"],
        designationId: json["designation_id"],
        companyId: json["company_id"],
        token: json["token"],
        tokenExpiry: DateTime.parse(json["token_expiry"]),
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "phone": phone,
        "name": name,
        "salary": salary,
        "department_id": departmentId,
        "designation_id": designationId,
        "company_id": companyId,
        "token": token,
        "token_expiry": tokenExpiry.toIso8601String(),
        "status": status,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}
