// To parse this JSON data, do
//
//     final designationModel = designationModelFromJson(jsonString);

import 'dart:convert';

DesignationModel designationModelFromJson(String str) => DesignationModel.fromJson(json.decode(str));

String designationModelToJson(DesignationModel data) => json.encode(data.toJson());

class DesignationModel {
    String status;
    Data data;

    DesignationModel({
        required this.status,
        required this.data,
    });

    factory DesignationModel.fromJson(Map<String, dynamic> json) => DesignationModel(
        status: json["status"],
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": data.toJson(),
    };
}

class Data {
    List<Designation> designations;
    Pagination pagination;

    Data({
        required this.designations,
        required this.pagination,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        designations: List<Designation>.from(json["designations"].map((x) => Designation.fromJson(x))),
        pagination: Pagination.fromJson(json["pagination"]),
    );

    Map<String, dynamic> toJson() => {
        "designations": List<dynamic>.from(designations.map((x) => x.toJson())),
        "pagination": pagination.toJson(),
    };
}

class Designation {
    int id;
    String name;
    dynamic companyId;
    DateTime createdAt;
    DateTime updatedAt;

    Designation({
        required this.id,
        required this.name,
        required this.companyId,
        required this.createdAt,
        required this.updatedAt,
    });

    factory Designation.fromJson(Map<String, dynamic> json) => Designation(
        id: json["id"],
        name: json["name"],
        companyId: json["company_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "company_id": companyId,
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
