class EmployeeModel {
  bool? isError;
  String? message;
  String? employeeId;
  List<EmployeeLists>? employeeLists;

  EmployeeModel(
      {this.isError, this.message, this.employeeId, this.employeeLists});

  EmployeeModel.fromJson(Map<String, dynamic> json) {
    isError = json['is_error'];
    message = json['message'];
    employeeId = json['employee_id'];
    if (json['employeeLists'] != null) {
      employeeLists = <EmployeeLists>[];
      json['employeeLists'].forEach((v) {
        employeeLists!.add(EmployeeLists.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['is_error'] = isError;
    data['message'] = message;
    data['employee_id'] = employeeId;
    if (employeeLists != null) {
      data['employeeLists'] =
          employeeLists!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  EmployeeModel.fromError({required bool isErrorThrown,required String errorMessage}){
    isError = isErrorThrown;
    message = errorMessage;
  }

}

class EmployeeLists {
  int? employeeId;
  int? designationId;
  String? employeeCode;
  String? employeeName;
  String? employeeType;
  String? employeeEmail;
  String? employeeMobile;
  String? employeeSkill;
  String? employeeAddress;
  String? userName;
  String? passwordLogin;
  String? employeeImage;
  String? isLogin;
  String? status;
  String? createdOn;
  int? createdBy;
  String? modifiedOn;
  int? modifiedBy;
  int? companyId;
  int? buId;
  int? plantId;
  int? departmentId;
  String? employeeGender;
  int? employeeLevel;
  int? employeeReportee;
  String? isEngineer;
  int? locationId;
  int? subUser;
  String? isAssigned;
  String? employeeImageUrl;
  String? createdUser;
  String? modifiedUser;
  String? company;
  String? bu;
  String? plant;
  String? department;
  String? designation;

  EmployeeLists(
      {this.employeeId,
      this.designationId,
      this.employeeCode,
      this.employeeName,
      this.employeeType,
      this.employeeEmail,
      this.employeeMobile,
      this.employeeSkill,
      this.employeeAddress,
      this.userName,
      this.passwordLogin,
      this.employeeImage,
      this.isLogin,
      this.status,
      this.createdOn,
      this.createdBy,
      this.modifiedOn,
      this.modifiedBy,
      this.companyId,
      this.buId,
      this.plantId,
      this.departmentId,
      this.employeeGender,
      this.employeeLevel,
      this.employeeReportee,
      this.isEngineer,
      this.locationId,
      this.subUser,
      this.isAssigned,
      this.employeeImageUrl,
      this.createdUser,
      this.modifiedUser,
      this.company,
      this.bu,
      this.plant,
      this.department,
      this.designation});

  EmployeeLists.fromJson(Map<String, dynamic> json) {
    employeeId = json['employee_id'];
    designationId = json['designation_id'];
    employeeCode = json['employee_code'];
    employeeName = json['employee_name'];
    employeeType = json['employee_type'];
    employeeEmail = json['employee_email'];
    employeeMobile = json['employee_mobile'];
    employeeSkill = json['employee_skill'];
    employeeAddress = json['employee_address'];
    userName = json['user_name'];
    passwordLogin = json['password_login'];
    employeeImage = json['employee_image'];
    isLogin = json['is_login'];
    status = json['status'];
    createdOn = json['created_on'];
    createdBy = json['created_by'];
    modifiedOn = json['modified_on'];
    modifiedBy = json['modified_by'];
    companyId = json['company_id'];
    buId = json['bu_id'];
    plantId = json['plant_id'];
    departmentId = json['department_id'];
    employeeGender = json['employee_gender'];
    employeeLevel = json['employee_level'];
    employeeReportee = json['employee_reportee'];
    isEngineer = json['is_engineer'];
    locationId = json['location_id'];
    subUser = json['sub_user'];
    isAssigned = json['is_assigned'];
    employeeImageUrl = json['employee_image_url'];
    createdUser = json['created_user'];
    modifiedUser = json['modified_user'];
    company = json['company'];
    bu = json['bu'];
    plant = json['plant'];
    department = json['department'];
    designation = json['designation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['employee_id'] = employeeId;
    data['designation_id'] = designationId;
    data['employee_code'] = employeeCode;
    data['employee_name'] = employeeName;
    data['employee_type'] = employeeType;
    data['employee_email'] = employeeEmail;
    data['employee_mobile'] = employeeMobile;
    data['employee_skill'] = employeeSkill;
    data['employee_address'] = employeeAddress;
    data['user_name'] = userName;
    data['password_login'] = passwordLogin;
    data['employee_image'] = employeeImage;
    data['is_login'] = isLogin;
    data['status'] = status;
    data['created_on'] = createdOn;
    data['created_by'] = createdBy;
    data['modified_on'] = modifiedOn;
    data['modified_by'] = modifiedBy;
    data['company_id'] = companyId;
    data['bu_id'] = buId;
    data['plant_id'] = plantId;
    data['department_id'] = departmentId;
    data['employee_gender'] = employeeGender;
    data['employee_level'] = employeeLevel;
    data['employee_reportee'] = employeeReportee;
    data['is_engineer'] = isEngineer;
    data['location_id'] = locationId;
    data['sub_user'] = subUser;
    data['is_assigned'] = isAssigned;
    data['employee_image_url'] = employeeImageUrl;
    data['created_user'] = createdUser;
    data['modified_user'] = modifiedUser;
    data['company'] = company;
    data['bu'] = bu;
    data['plant'] = plant;
    data['department'] = department;
    data['designation'] = designation;
    return data;
  }
}
