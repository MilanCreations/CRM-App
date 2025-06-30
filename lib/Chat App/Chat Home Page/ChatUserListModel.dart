// To parse this JSON data, do
//
//     final chatUserListModel = chatUserListModelFromJson(jsonString);

import 'dart:convert';

ChatUserListModel chatUserListModelFromJson(String str) => ChatUserListModel.fromJson(json.decode(str));

String chatUserListModelToJson(ChatUserListModel data) => json.encode(data.toJson());

class ChatUserListModel {
    bool status;
    List<User> user;
    int total;
    String filterCount;

    ChatUserListModel({
        required this.status,
        required this.user,
        required this.total,
        required this.filterCount,
    });

    factory ChatUserListModel.fromJson(Map<String, dynamic> json) => ChatUserListModel(
        status: json["status"],
        user: List<User>.from(json["user"].map((x) => User.fromJson(x))),
        total: json["total"],
        filterCount: json["filterCount"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "user": List<dynamic>.from(user.map((x) => x.toJson())),
        "total": total,
        "filterCount": filterCount,
    };
}

class User {
    int id;
    String username;
    String fullname;
    String? name;
    String? profilePic;
    String? departmentName;
    String? designation;
    int roleid;
    String roleName;
    String roleCode;
    DateTime lastActivity;
    String unreadCount;

    User({
        required this.id,
        required this.username,
        required this.fullname,
        required this.name,
        required this.profilePic,
        required this.departmentName,
        required this.designation,
        required this.roleid,
        required this.roleName,
        required this.roleCode,
        required this.lastActivity,
        required this.unreadCount,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        username: json["username"],
        fullname: json["fullname"],
        name: json["name"]?? "",
        profilePic: json["profile_pic"] ?? "",
        departmentName: json["department_name"]?? "",
        designation: json["designation"]?? "",
        roleid: json["roleid"],
        roleName: json["role_name"],
        roleCode: json["role_code"],
        lastActivity: DateTime.parse(json["last_activity"]),
        unreadCount: json["unread_count"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "fullname": fullname,
        "name": name,
        "profile_pic": profilePic,
        "department_name": departmentName,
        "designation": designation,
        "roleid": roleid,
        "role_name": roleName,
        "role_code": roleCode,
        "last_activity": lastActivity.toIso8601String(),
        "unread_count": unreadCount,
    };
}
