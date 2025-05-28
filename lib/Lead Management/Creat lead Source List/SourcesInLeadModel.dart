// To parse this JSON data, do
//
//     final sourceLeadDetailsModel = sourceLeadDetailsModelFromJson(jsonString);

import 'dart:convert';

SourceLeadDetailsModel sourceLeadDetailsModelFromJson(String str) => SourceLeadDetailsModel.fromJson(json.decode(str));

String sourceLeadDetailsModelToJson(SourceLeadDetailsModel data) => json.encode(data.toJson());

class SourceLeadDetailsModel {
    String status;
    List<Source> sources;

    SourceLeadDetailsModel({
        required this.status,
        required this.sources,
    });

    factory SourceLeadDetailsModel.fromJson(Map<String, dynamic> json) => SourceLeadDetailsModel(
        status: json["status"],
        sources: List<Source>.from(json["sources"].map((x) => Source.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "sources": List<dynamic>.from(sources.map((x) => x.toJson())),
    };
}

class Source {
    String name;

    Source({
        required this.name,
    });

    factory Source.fromJson(Map<String, dynamic> json) => Source(
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
    };
}
