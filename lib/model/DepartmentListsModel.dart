class DepartmentListsModel {
  bool? isError;
  String? message;
  String? departmentId;
  List<DepartmentLists>? departmentLists;

  DepartmentListsModel(
      {this.isError, this.message, this.departmentId, this.departmentLists});

  DepartmentListsModel.fromJson(Map<String, dynamic> json) {
    isError = json['is_error'];
    message = json['message'];
    departmentId = json['department_id'];
    if (json['departmentLists'] != null) {
      departmentLists = <DepartmentLists>[];
      json['departmentLists'].forEach((v) {
        departmentLists!.add(DepartmentLists.fromJson(v));
      });
    }
  }
  DepartmentListsModel.fromError(
      {required bool isErrorThrown, required String errorMessage}) {
    isError = isErrorThrown;
    message = errorMessage;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['is_error'] = isError;
    data['message'] = message;
    data['department_id'] = departmentId;
    if (departmentLists != null) {
      data['departmentLists'] =
          departmentLists!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DepartmentLists {
  int? departmentId;
  int? companyId;
  int? buId;
  int? plantId;
  String? departmentCode;
  String? departmentName;
  String? status;
  String? isMttr;
  String? createdOn;
  int? createdBy;
  String? modifiedOn;
  int? modifiedBy;
  String? isMultiple;
  String? isDowntime;
  String? isAssigned;
  String? companyName;
  String? buName;
  String? plantName;
  String? createdUser;
  String? modifiedUser;

  DepartmentLists(
      {this.departmentId,
      this.companyId,
      this.buId,
      this.plantId,
      this.departmentCode,
      this.departmentName,
      this.status,
      this.isMttr,
      this.createdOn,
      this.createdBy,
      this.modifiedOn,
      this.modifiedBy,
      this.isMultiple,
      this.isDowntime,
      this.isAssigned,
      this.companyName,
      this.buName,
      this.plantName,
      this.createdUser,
      this.modifiedUser});

  DepartmentLists.fromJson(Map<String, dynamic> json) {
    departmentId = json['department_id'];
    companyId = json['company_id'];
    buId = json['bu_id'];
    plantId = json['plant_id'];
    departmentCode = json['department_code'];
    departmentName = json['department_name'];
    status = json['status'];
    isMttr = json['is_mttr'];
    createdOn = json['created_on'];
    createdBy = json['created_by'];
    modifiedOn = json['modified_on'];
    modifiedBy = json['modified_by'];
    isMultiple = json['is_multiple'];
    isDowntime = json['is_downtime'];
    isAssigned = json['is_assigned'];
    companyName = json['company_name'];
    buName = json['bu_name'];
    plantName = json['plant_name'];
    createdUser = json['created_user'];
    modifiedUser = json['modified_user'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['department_id'] = departmentId;
    data['company_id'] = companyId;
    data['bu_id'] = buId;
    data['plant_id'] = plantId;
    data['department_code'] = departmentCode;
    data['department_name'] = departmentName;
    data['status'] = status;
    data['is_mttr'] = isMttr;
    data['created_on'] = createdOn;
    data['created_by'] = createdBy;
    data['modified_on'] = modifiedOn;
    data['modified_by'] = modifiedBy;
    data['is_multiple'] = isMultiple;
    data['is_downtime'] = isDowntime;
    data['is_assigned'] = isAssigned;
    data['company_name'] = companyName;
    data['bu_name'] = buName;
    data['plant_name'] = plantName;
    data['created_user'] = createdUser;
    data['modified_user'] = modifiedUser;
    return data;
  }
}
