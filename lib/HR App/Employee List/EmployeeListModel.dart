// To parse this JSON data, do
//
//     final employeeList = employeeListFromJson(jsonString);

import 'dart:convert';

EmployeeList employeeListFromJson(String str) => EmployeeList.fromJson(json.decode(str));

String employeeListToJson(EmployeeList data) => json.encode(data.toJson());

class EmployeeList {
    String status;
    List<Result> result;
    int total;
    String filterCount;

    EmployeeList({
        required this.status,
        required this.result,
        required this.total,
        required this.filterCount,
    });

    factory EmployeeList.fromJson(Map<String, dynamic> json) => EmployeeList(
        status: json["status"],
        result: List<Result>.from(json["result"].map((x) => Result.fromJson(x))),
        total: json["total"],
        filterCount: json["filterCount"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "result": List<dynamic>.from(result.map((x) => x.toJson())),
        "total": total,
        "filterCount": filterCount,
    };
}

class Result {
    int id;
    String email;
    String phone;
    dynamic dateOfBirth;
    String gender;
    String address;
    DateTime joinDate;
    String salary;
    String bankAccount;
    String bankName;
    String ifscCode;
    dynamic companyId;
    DateTime createdAt;
    DateTime updatedAt;
    int departmentId;
    int designationId;
    String password;
    String panCardNumber;
    String aadharCardNumber;
    String profilePic;
    String panCardDoc;
    String aadharCardDoc;
    String employeeNumber;
    String name;
    bool isAdmin;
    int userId;
    String status;
    bool birthdayNotificationEnabled;
    String? emergencyContact;
    Department department;
    Department designation;
    List<dynamic> skills;
    User user;

    Result({
        required this.id,
        required this.email,
        required this.phone,
        required this.dateOfBirth,
        required this.gender,
        required this.address,
        required this.joinDate,
        required this.salary,
        required this.bankAccount,
        required this.bankName,
        required this.ifscCode,
        required this.companyId,
        required this.createdAt,
        required this.updatedAt,
        required this.departmentId,
        required this.designationId,
        required this.password,
        required this.panCardNumber,
        required this.aadharCardNumber,
        required this.profilePic,
        required this.panCardDoc,
        required this.aadharCardDoc,
        required this.employeeNumber,
        required this.name,
        required this.isAdmin,
        required this.userId,
        required this.status,
        required this.birthdayNotificationEnabled,
        required this.emergencyContact,
        required this.department,
        required this.designation,
        required this.skills,
        required this.user,
    });

    factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        email: json["email"],
        phone: json["phone"],
        dateOfBirth: json["date_of_birth"]?? "",
        gender: json["gender"],
        address: json["address"],
        joinDate: DateTime.parse(json["join_date"]),
        salary: json["salary"],
        bankAccount: json["bank_account"],
        bankName: json["bank_name"],
        ifscCode: json["ifsc_code"],
        companyId: json["company_id"]?? 0,
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        departmentId: json["department_id"],
        designationId: json["designation_id"],
        password: json["password"],
        panCardNumber: json["pan_card_number"],
        aadharCardNumber: json["aadhar_card_number"],
        profilePic: json["profile_pic"],
        panCardDoc: json["pan_card_doc"],
        aadharCardDoc: json["aadhar_card_doc"],
        employeeNumber: json["employee_number"],
        name: json["name"],
        isAdmin: json["is_admin"],
        userId: json["user_id"],
        status: json["status"],
        birthdayNotificationEnabled: json["birthday_notification_enabled"],
        emergencyContact: json["emergency_contact"]?? "",
        department: Department.fromJson(json["department"]),
        designation: Department.fromJson(json["designation"]),
        skills: List<dynamic>.from(json["skills"].map((x) => x)),
        user: User.fromJson(json["user"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "phone": phone,
        "date_of_birth": dateOfBirth,
        "gender": gender,
        "address": address,
        "join_date": joinDate.toIso8601String(),
        "salary": salary,
        "bank_account": bankAccount,
        "bank_name": bankName,
        "ifsc_code": ifscCode,
        "company_id": companyId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "department_id": departmentId,
        "designation_id": designationId,
        "password": password,
        "pan_card_number": panCardNumber,
        "aadhar_card_number": aadharCardNumber,
        "profile_pic": profilePic,
        "pan_card_doc": panCardDoc,
        "aadhar_card_doc": aadharCardDoc,
        "employee_number": employeeNumber,
        "name": name,
        "is_admin": isAdmin,
        "user_id": userId,
        "status": status,
        "birthday_notification_enabled": birthdayNotificationEnabled,
        "emergency_contact": emergencyContact,
        "department": department.toJson(),
        "designation": designation.toJson(),
        "skills": List<dynamic>.from(skills.map((x) => x)),
        "user": user.toJson(),
    };
}

class Department {
    int id;
    String name;
    DateTime createdAt;
    DateTime updatedAt;
    dynamic companyId;

    Department({
        required this.id,
        required this.name,
        required this.createdAt,
        required this.updatedAt,
        this.companyId,
    });

    factory Department.fromJson(Map<String, dynamic> json) => Department(
        id: json["id"],
        name: json["name"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        companyId: json["company_id"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "company_id": companyId,
    };
}

class User {
    String role;

    User({
        required this.role,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        role: json["role"],
    );

    Map<String, dynamic> toJson() => {
        "role": role,
    };
}
