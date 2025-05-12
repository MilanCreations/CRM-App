// To parse this JSON data, do
//
//     final profilwModel = profilwModelFromJson(jsonString);

import 'dart:convert';

ProfilwModel profilwModelFromJson(String str) => ProfilwModel.fromJson(json.decode(str));

String profilwModelToJson(ProfilwModel data) => json.encode(data.toJson());

class ProfilwModel {
    int id;
    String fullname;
    String email;
    String username;
    int roleId;
    dynamic companyId;
    int employeeId;
    String roleName;
    String roleCode;
    dynamic companyName;
    dynamic companyIsActive;
    String profilePic;
    String name;
    String phone;
    String address;
    String emergencyContact;
    DateTime joinDate;
    String salary;
    String bankAccount;
    String bankName;
    String ifscCode;
    String departmentName;
    String designation;
    String shiftStart;
    String shiftEnd;
    List<dynamic> documents;

    ProfilwModel({
        required this.id,
        required this.fullname,
        required this.email,
        required this.username,
        required this.roleId,
        required this.companyId,
        required this.employeeId,
        required this.roleName,
        required this.roleCode,
        required this.companyName,
        required this.companyIsActive,
        required this.profilePic,
        required this.name,
        required this.phone,
        required this.address,
        required this.emergencyContact,
        required this.joinDate,
        required this.salary,
        required this.bankAccount,
        required this.bankName,
        required this.ifscCode,
        required this.departmentName,
        required this.designation,
        required this.shiftStart,
        required this.shiftEnd,
        required this.documents,
    });

    factory ProfilwModel.fromJson(Map<String, dynamic> json) => ProfilwModel(
        id: json["id"]?? 0,
        fullname: json["fullname"]?? "",
        email: json["email"]?? "",
        username: json["username"]?? "",
        roleId: json["role_id"]?? 0,
        companyId: json["company_id"]?? 0,
        employeeId: json["employee_id"]?? 0,
        roleName: json["role_name"]?? "",
        roleCode: json["role_code"]?? 0,
        companyName: json["companyName"]?? "",
        companyIsActive: json["company_is_active"]?? false,
        profilePic: json["profile_pic"]?? "",
        name: json["name"]?? "",
        phone: json["phone"]?? "",
        address: json["address"]?? "",
        emergencyContact: json["emergency_contact"]?? "",
        joinDate: DateTime.parse(json["join_date"]?? ""),
        salary: json["salary"]?? "",
        bankAccount: json["bank_account"]?? "",
        bankName: json["bank_name"]?? "",
        ifscCode: json["ifsc_code"]?? "",
        departmentName: json["department_name"]?? "",
        designation: json["designation"]?? "",
        shiftStart: json["shift_start"]?? "",
        shiftEnd: json["shift_end"]?? "",
        documents: List<dynamic>.from(json["documents"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "fullname": fullname,
        "email": email,
        "username": username,
        "role_id": roleId,
        "company_id": companyId,
        "employee_id": employeeId,
        "role_name": roleName,
        "role_code": roleCode,
        "companyName": companyName,
        "company_is_active": companyIsActive,
        "profile_pic": profilePic,
        "name": name,
        "phone": phone,
        "address": address,
        "emergency_contact": emergencyContact,
        "join_date": joinDate.toIso8601String(),
        "salary": salary,
        "bank_account": bankAccount,
        "bank_name": bankName,
        "ifsc_code": ifscCode,
        "department_name": departmentName,
        "designation": designation,
        "shift_start": shiftStart,
        "shift_end": shiftEnd,
        "documents": List<dynamic>.from(documents.map((x) => x)),
    };
}
