// To parse this JSON data, do
//
//     final employeedetails = employeedetailsFromJson(jsonString);

import 'dart:convert';

Employeedetails employeedetailsFromJson(String str) => Employeedetails.fromJson(json.decode(str));

String employeedetailsToJson(Employeedetails data) => json.encode(data.toJson());

class Employeedetails {
    String status;
    Data data;

    Employeedetails({
        required this.status,
        required this.data,
    });

    factory Employeedetails.fromJson(Map<String, dynamic> json) => Employeedetails(
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
    dynamic emergencyContact;
    Department department;
    Department designation;
    List<dynamic> skills;
    List<dynamic> timesheets;
    Role role;
    List<dynamic> documentType;

    Data({
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
        required this.timesheets,
        required this.role,
        required this.documentType,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
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
        timesheets: List<dynamic>.from(json["timesheets"].map((x) => x)),
        role: Role.fromJson(json["role"]),
        documentType: List<dynamic>.from(json["document_type"].map((x) => x)),
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
        "timesheets": List<dynamic>.from(timesheets.map((x) => x)),
        "role": role.toJson(),
        "document_type": List<dynamic>.from(documentType.map((x) => x)),
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
        companyId: json["company_id"]??0,
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "company_id": companyId,
    };
}

class Role {
    int id;
    String name;
    String code;
    dynamic description;
    bool isActive;
    DateTime createdAt;
    DateTime updatedAt;

    Role({
        required this.id,
        required this.name,
        required this.code,
        required this.description,
        required this.isActive,
        required this.createdAt,
        required this.updatedAt,
    });

    factory Role.fromJson(Map<String, dynamic> json) => Role(
        id: json["id"],
        name: json["name"],
        code: json["code"],
        description: json["description"]?? "",
        isActive: json["is_active"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "code": code,
        "description": description,
        "is_active": isActive,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}
