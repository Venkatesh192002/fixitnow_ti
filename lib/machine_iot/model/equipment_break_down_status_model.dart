class EquipmentBreakDownStatusModel {
  bool? isError;
  String? message;
  String? breakdownStatusId;
  List<BreakdownStatusLists>? breakdownStatusLists;

  EquipmentBreakDownStatusModel(
      {this.isError,
      this.message,
      this.breakdownStatusId,
      this.breakdownStatusLists});

  EquipmentBreakDownStatusModel.fromJson(Map<String, dynamic> json) {
    isError = json['is_error'];
    message = json['message'];
    breakdownStatusId = json['breakdown_status_id'];
    if (json['breakdown_statusLists'] != null) {
      breakdownStatusLists = <BreakdownStatusLists>[];
      json['breakdown_statusLists'].forEach((v) {
        breakdownStatusLists!.add(BreakdownStatusLists.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['is_error'] = isError;
    data['message'] = message;
    data['breakdown_status_id'] = breakdownStatusId;
    if (breakdownStatusLists != null) {
      data['breakdown_statusLists'] =
          breakdownStatusLists!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  EquipmentBreakDownStatusModel.fromError({required bool isErrorThrown,required String errorMessage}){
    isError = isErrorThrown;
    message = errorMessage;
  }
}

class BreakdownStatusLists {
  int? companyId;
  int? buId;
  int? plantId;
  String? breakdownStatus;
  String? createdOn;
  int? createdBy;
  String? modifiedOn;
  int? modifiedBy;
  int? breakdownStatusId;
  String? status;
  String? createdUser;
  String? modifiedUser;

  BreakdownStatusLists(
      {this.companyId,
      this.buId,
      this.plantId,
      this.breakdownStatus,
      this.createdOn,
      this.createdBy,
      this.modifiedOn,
      this.modifiedBy,
      this.breakdownStatusId,
      this.status,
      this.createdUser,
      this.modifiedUser});

  BreakdownStatusLists.fromJson(Map<String, dynamic> json) {
    companyId = json['company_id'];
    buId = json['bu_id'];
    plantId = json['plant_id'];
    breakdownStatus = json['breakdown_status'];
    createdOn = json['created_on'];
    createdBy = json['created_by'];
    modifiedOn = json['modified_on'];
    modifiedBy = json['modified_by'];
    breakdownStatusId = json['breakdown_status_id'];
    status = json['status'];
    createdUser = json['created_user'];
    modifiedUser = json['modified_user'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['company_id'] = companyId;
    data['bu_id'] = buId;
    data['plant_id'] = plantId;
    data['breakdown_status'] = breakdownStatus;
    data['created_on'] = createdOn;
    data['created_by'] = createdBy;
    data['modified_on'] = modifiedOn;
    data['modified_by'] = modifiedBy;
    data['breakdown_status_id'] = breakdownStatusId;
    data['status'] = status;
    data['created_user'] = createdUser;
    data['modified_user'] = modifiedUser;
    return data;
  }
}
