// To parse this JSON data, do
//
//     final rootCauseModel = rootCauseModelFromJson(jsonString);

import 'dart:convert';

RootCauseModel rootCauseModelFromJson(String str) =>
    RootCauseModel.fromJson(json.decode(str));

String rootCauseModelToJson(RootCauseModel data) => json.encode(data.toJson());

class RootCauseModel {
  bool isError;
  String message;
  List<RootCauseList> rootCauseLists;

  RootCauseModel({
    required this.isError,
    required this.message,
    required this.rootCauseLists,
  });

  factory RootCauseModel.fromJson(Map<String, dynamic> json) => RootCauseModel(
        isError: json["is_error"],
        message: json["message"],
        rootCauseLists: List<RootCauseList>.from(
            json["root_causeLists"].map((x) => RootCauseList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "is_error": isError,
        "message": message,
        "root_causeLists":
            List<dynamic>.from(rootCauseLists.map((x) => x.toJson())),
      };
}

class RootCauseList {
  int? id;
  int? refId;
  int? companyId;
  int? buId;
  int? plantId;
  int? pillarId;
  String? rootCauseCode;
  String? rootCauseName;
  String? status;
  DateTime? createdOn;
  int? createdBy;
  String? modifiedOn;
  int? modifiedBy;

  RootCauseList({
    this.id,
    this.refId,
    this.companyId,
    this.buId,
    this.plantId,
    this.pillarId,
    this.rootCauseCode,
    this.rootCauseName,
    this.status,
    this.createdOn,
    this.createdBy,
    this.modifiedOn,
    this.modifiedBy,
  });

  factory RootCauseList.fromJson(Map<String, dynamic> json) => RootCauseList(
        id: json["id"],
        refId: json["ref_id"],
        companyId: json["company_id"],
        buId: json["bu_id"],
        plantId: json["plant_id"],
        pillarId: json["pillar_id"],
        rootCauseCode: json["root_cause_code"],
        rootCauseName: json["root_cause_name"],
        status: json["status"],
        createdOn: DateTime.parse(json["created_on"]),
        createdBy: json["created_by"],
        modifiedOn: json["modified_on"],
        modifiedBy: json["modified_by"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "ref_id": refId,
        "company_id": companyId,
        "bu_id": buId,
        "plant_id": plantId,
        "pillar_id": pillarId,
        "root_cause_code": rootCauseCode,
        "root_cause_name": rootCauseName,
        "status": status,
        "created_on": createdOn == null || createdOn == ""
            ? ""
            : createdOn?.toIso8601String(),
        "created_by": createdBy,
        "modified_on": modifiedOn,
        "modified_by": modifiedBy,
      };
}
