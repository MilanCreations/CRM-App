// To parse this JSON data, do
//
//     final messageModel = messageModelFromJson(jsonString);

import 'dart:convert';

MessageModel messageModelFromJson(String str) => MessageModel.fromJson(json.decode(str));

String messageModelToJson(MessageModel data) => json.encode(data.toJson());

class MessageModel {
    bool status;
    List<Datum> data;
    int totalCount;
    int filteredCount;

    MessageModel({
        required this.status,
        required this.data,
        required this.totalCount,
        required this.filteredCount,
    });

    factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
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
    int senderId;
    int receiverId;
    dynamic groupId;
    String message;
    String messageType;
    String status;
    DateTime createdAt;
    DateTime updatedAt;

    Datum({
        required this.id,
        required this.senderId,
        required this.receiverId,
        required this.groupId,
        required this.message,
        required this.messageType,
        required this.status,
        required this.createdAt,
        required this.updatedAt,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        senderId: json["sender_id"],
        receiverId: json["receiver_id"],
        groupId: json["group_id"],
        message: json["message"],
        messageType: json["message_type"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "sender_id": senderId,
        "receiver_id": receiverId,
        "group_id": groupId,
        "message": message,
        "message_type": messageType,
        "status": status,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}
