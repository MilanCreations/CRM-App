// To parse this JSON data, do
//
//     final createNewCompanyModel = createNewCompanyModelFromJson(jsonString);

import 'dart:convert';

CreateNewCompanyModel createNewCompanyModelFromJson(String str) =>
    CreateNewCompanyModel.fromJson(json.decode(str));

String createNewCompanyModelToJson(CreateNewCompanyModel data) =>
    json.encode(data.toJson());

class CreateNewCompanyModel {
  bool success;
  String message;
  Data data;
  String activationToken;

  CreateNewCompanyModel({
    required this.success,
    required this.message,
    required this.data,
    required this.activationToken,
  });

  factory CreateNewCompanyModel.fromJson(Map<String, dynamic> json) =>
      CreateNewCompanyModel(
        success: json["success"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
        activationToken: json["activationToken"],
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data.toJson(),
    "activationToken": activationToken,
  };
}

class Data {
  int id;
  String companyName;
  int companyType;
  int country;
  int state;
  int city;
  String address;
  String adminName;
  String adminEmail;
  String phone;
  String gstId;
  String companyLogo;
  bool isActive;
  DateTime createdAt;
  DateTime updatedAt;

  Data({
    required this.id,
    required this.companyName,
    required this.companyType,
    required this.country,
    required this.state,
    required this.city,
    required this.address,
    required this.adminName,
    required this.adminEmail,
    required this.phone,
    required this.gstId,
    required this.companyLogo,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    companyName: json["companyName"],
    companyType: json["companyType"],
    country: json["country"],
    state: json["state"],
    city: json["city"],
    address: json["address"],
    adminName: json["adminName"],
    adminEmail: json["adminEmail"],
    phone: json["phone"],
    gstId: json["gst_id"],
    companyLogo: json["companyLogo"],
    isActive: json["is_active"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "companyName": companyName,
    "companyType": companyType,
    "country": country,
    "state": state,
    "city": city,
    "address": address,
    "adminName": adminName,
    "adminEmail": adminEmail,
    "phone": phone,
    "gst_id": gstId,
    "companyLogo": companyLogo,
    "is_active": isActive,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
