// To parse this JSON data, do
//
//     final forgotPasswordModel = forgotPasswordModelFromJson(jsonString);

import 'dart:convert';

ForgotPasswordModel forgotPasswordModelFromJson(String str) =>
    ForgotPasswordModel.fromJson(json.decode(str));

String forgotPasswordModelToJson(ForgotPasswordModel data) =>
    json.encode(data.toJson());

class ForgotPasswordModel {
  bool? status;
  String message;
  String? activationToken;

  ForgotPasswordModel({
    this.status,
    required this.message,
    this.activationToken,
  });

  factory ForgotPasswordModel.fromJson(Map<String, dynamic> json) =>
      ForgotPasswordModel(
        status: json["status"],
        message: json["message"] ?? 'No message',
        activationToken: json["activationToken"],
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "activationToken": activationToken,
  };
}
