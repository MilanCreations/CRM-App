// To parse this JSON data, do
//
//     final notificationsModel = notificationsModelFromJson(jsonString);

import 'dart:convert';

NotificationsModel notificationsModelFromJson(String str) => NotificationsModel.fromJson(json.decode(str));

String notificationsModelToJson(NotificationsModel data) => json.encode(data.toJson());

class NotificationsModel {
    bool status;
    List<Datum> data;
    int totalCount;
    int filteredCount;

    NotificationsModel({
        required this.status,
        required this.data,
        required this.totalCount,
        required this.filteredCount,
    });

    factory NotificationsModel.fromJson(Map<String, dynamic> json) => NotificationsModel(
        status: json["status"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        totalCount: json["totalCount"],
        filteredCount: json["filteredCount"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "totalCount": totalCount,
        "filteredCount": filteredCount,
    };
}

class Datum {
    int id;
    int userId;
    String title;
    String body;
    dynamic data;
    bool isRead;
    DateTime createdAt;

    Datum({
        required this.id,
        required this.userId,
        required this.title,
        required this.body,
        required this.data,
        required this.isRead,
        required this.createdAt,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        userId: json["user_id"],
        title: json["title"],
        body: json["body"],
        data: json["data"],
        isRead: json["is_read"],
        createdAt: DateTime.parse(json["created_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "title": title,
        "body": body,
        "data": data,
        "is_read": isRead,
        "created_at": createdAt.toIso8601String(),
    };
}
