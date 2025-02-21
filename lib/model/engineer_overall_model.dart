class EngineerOverallListModel {
  bool? isError;
  String? message;
  String? departmentEngineerId;
  List<DepartmentEngineerLists>? departmentEngineerLists;

  EngineerOverallListModel(
      {this.isError,
      this.message,
      this.departmentEngineerId,
      this.departmentEngineerLists});

  EngineerOverallListModel.fromJson(Map<String, dynamic> json) {
    isError = json['is_error'];
    message = json['message'];
    departmentEngineerId = json['department_engineer_id'];
    if (json['department_engineerLists'] != null) {
      departmentEngineerLists = <DepartmentEngineerLists>[];
      json['department_engineerLists'].forEach((v) {
        departmentEngineerLists!.add(new DepartmentEngineerLists.fromJson(v));
      });
    }
  }

  EngineerOverallListModel.fromError(
      {required bool isErrorThrown, required String errorMessage}) {
    isError = isErrorThrown;
    message = errorMessage;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['is_error'] = this.isError;
    data['message'] = this.message;
    data['department_engineer_id'] = this.departmentEngineerId;
    if (this.departmentEngineerLists != null) {
      data['department_engineerLists'] =
          this.departmentEngineerLists!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DepartmentEngineerLists {
  int? departmentEngineerId;
  int? companyId;
  int? buId;
  int? plantId;
  List<int>? departmentId;
  int? employeeId;
  String? status;
  String? createdOn;
  int? createdBy;
  String? modifiedOn;
  int? modifiedBy;
  String? companyName;
  String? buName;
  String? plantName;
  String? createdUser;
  String? modifiedUser;
  String? employee;
  String? departmentName;

  DepartmentEngineerLists(
      {this.departmentEngineerId,
      this.companyId,
      this.buId,
      this.plantId,
      this.departmentId,
      this.employeeId,
      this.status,
      this.createdOn,
      this.createdBy,
      this.modifiedOn,
      this.modifiedBy,
      this.companyName,
      this.buName,
      this.plantName,
      this.createdUser,
      this.modifiedUser,
      this.employee,
      this.departmentName});

  DepartmentEngineerLists.fromJson(Map<String, dynamic> json) {
    departmentEngineerId = json['department_engineer_id'];
    companyId = json['company_id'];
    buId = json['bu_id'];
    plantId = json['plant_id'];
    departmentId = json['department_id'].cast<int>();
    employeeId = json['employee_id'];
    status = json['status'];
    createdOn = json['created_on'];
    createdBy = json['created_by'];
    modifiedOn = json['modified_on'];
    modifiedBy = json['modified_by'];
    companyName = json['company_name'];
    buName = json['bu_name'];
    plantName = json['plant_name'];
    createdUser = json['created_user'];
    modifiedUser = json['modified_user'];
    employee = json['employee'];
    departmentName = json['department_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['department_engineer_id'] = this.departmentEngineerId;
    data['company_id'] = this.companyId;
    data['bu_id'] = this.buId;
    data['plant_id'] = this.plantId;
    data['department_id'] = this.departmentId;
    data['employee_id'] = this.employeeId;
    data['status'] = this.status;
    data['created_on'] = this.createdOn;
    data['created_by'] = this.createdBy;
    data['modified_on'] = this.modifiedOn;
    data['modified_by'] = this.modifiedBy;
    data['company_name'] = this.companyName;
    data['bu_name'] = this.buName;
    data['plant_name'] = this.plantName;
    data['created_user'] = this.createdUser;
    data['modified_user'] = this.modifiedUser;
    data['employee'] = this.employee;
    data['department_name'] = this.departmentName;
    return data;
  }
}
