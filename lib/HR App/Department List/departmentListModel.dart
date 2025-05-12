// To parse this JSON data, do
//
//     final departmentModel = departmentModelFromJson(jsonString);

import 'dart:convert';

DepartmentModel departmentModelFromJson(String str) => DepartmentModel.fromJson(json.decode(str));

String departmentModelToJson(DepartmentModel data) => json.encode(data.toJson());

class DepartmentModel {
    String status;
    Data data;

    DepartmentModel({
        required this.status,
        required this.data,
    });

    factory DepartmentModel.fromJson(Map<String, dynamic> json) => DepartmentModel(
        status: json["status"],
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": data.toJson(),
    };
}

class Data {
    List<Department> departments;
    Pagination pagination;

    Data({
        required this.departments,
        required this.pagination,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        departments: List<Department>.from(json["departments"].map((x) => Department.fromJson(x))),
        pagination: Pagination.fromJson(json["pagination"]),
    );

    Map<String, dynamic> toJson() => {
        "departments": List<dynamic>.from(departments.map((x) => x.toJson())),
        "pagination": pagination.toJson(),
    };
}

class Department {
    int id;
    String name;
    DateTime createdAt;
    DateTime updatedAt;

    Department({
        required this.id,
        required this.name,
        required this.createdAt,
        required this.updatedAt,
    });

    factory Department.fromJson(Map<String, dynamic> json) => Department(
        id: json["id"],
        name: json["name"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}

class Pagination {
    int page;
    int limit;
    int total;

    Pagination({
        required this.page,
        required this.limit,
        required this.total,
    });

    factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        page: json["page"],
        limit: json["limit"],
        total: json["total"],
    );

    Map<String, dynamic> toJson() => {
        "page": page,
        "limit": limit,
        "total": total,
    };
}
