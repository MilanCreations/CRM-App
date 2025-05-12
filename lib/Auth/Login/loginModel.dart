// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);

import 'dart:convert';

LoginModel loginModelFromJson(String str) => LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
    bool status;
    String message;
    String token;
    String tokenType;
    String expiresIn;
    User user;

    LoginModel({
        required this.status,
        required this.message,
        required this.token,
        required this.tokenType,
        required this.expiresIn,
        required this.user,
    });

    factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        status: json["status"],
        message: json["message"],
        token: json["token"],
        tokenType: json["token_type"],
        expiresIn: json["expires_in"],
        user: User.fromJson(json["user"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "token": token,
        "token_type": tokenType,
        "expires_in": expiresIn,
        "user": user.toJson(),
    };
}

class User {
    int id;
    String fullname;
    String username;
    String email;
    int roleId;
    String roleName;
    String roleCode;
    dynamic companyId;
    dynamic companyName;
    int employeeId;
    String profilePic;
    String name;
    String designation;

    User({
        required this.id,
        required this.fullname,
        required this.username,
        required this.email,
        required this.roleId,
        required this.roleName,
        required this.roleCode,
        required this.companyId,
        required this.companyName,
        required this.employeeId,
        required this.profilePic,
        required this.name,
        required this.designation,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        fullname: json["fullname"],
        username: json["username"],
        email: json["email"],
        roleId: json["role_id"],
        roleName: json["role_name"],
        roleCode: json["role_code"],
        companyId: json["company_id"] ?? 0,
        companyName: json["company_name"] ?? "",
        employeeId: json["employee_id"]?? 0,
        profilePic: json["profile_pic"]?? "",
        name: json["name"]?? "",
        designation: json["designation"]?? "",
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "fullname": fullname,
        "username": username,
        "email": email,
        "role_id": roleId,
        "role_name": roleName,
        "role_code": roleCode,
        "company_id": companyId,
        "company_name": companyName,
        "employee_id": employeeId,
        "profile_pic": profilePic,
        "name": name,
        "designation": designation,
    };
}
