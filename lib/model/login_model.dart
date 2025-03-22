// class LoginModel {
//   LoginModel({
//     required this.iserror,
//     required this.message,
//     required this.login,
//   });
//   late final bool iserror;
//   late final String message;
//   late final String shield;
//   late final String shield1;
//   late final List<Login>? login;

//   LoginModel.fromJson(Map<String, dynamic> json) {
//     iserror = json['iserror'];
//     message = json['message'];
//     shield = json['shield'] ?? "empty";
//     shield1 = json['shield1'] ?? "empty";
//     login = json["login"] == null
//         ? null
//         : List.from(json['login']).map((e) => Login.fromJson(e)).toList();
//   }

//   Map<String, dynamic> toJson() {
//     final _data = <String, dynamic>{};
//     _data['iserror'] = iserror;
//     _data['message'] = message;
//     _data['shield'] = shield;
//     _data['login'] = login?.map((e) => e.toJson()).toList();
//     return _data;
//   }
// }

// class Login {
//   Login({
//     required this.employeeId,
//     required this.companyId,
//     required this.buId,
//     required this.plantId,
//     required this.userLevelId,
//     required this.employeeCode,
//     required this.employeeName,
//     required this.employeeType,
//     required this.employeeImage,
//     required this.mobileNo,
//     required this.email,
//     required this.designation,
//     required this.isLogin,
//     required this.passwordLogin,
//     required this.status,
//     required this.lastlogin,
//     required this.isFirstPassword,
//     required this.createdOn,
//     required this.createdBy,
//     required this.modifiedOn,
//     required this.modifiedBy,
//     required this.syncStatus,
//     required this.token,
//     required this.companyCode,
//     required this.companyName,
//     required this.buCode,
//     required this.buName,
//     required this.plantCode,
//     required this.plantName,
//     required this.EmployeeImageUrl,
//   });
//   late final dynamic employeeId;
//   late final dynamic companyId;
//   late final dynamic buId;
//   late final dynamic plantId;
//   late final dynamic userLevelId;
//   late final dynamic employeeCode;
//   late final dynamic employeeName;
//   late final dynamic employeeType;
//   late final dynamic employeeImage;
//   late final dynamic mobileNo;
//   late final dynamic email;
//   late final dynamic designation;
//   late final dynamic isLogin;
//   late final dynamic passwordLogin;
//   late final dynamic status;
//   late final dynamic lastlogin;
//   late final dynamic isFirstPassword;
//   late final dynamic createdOn;
//   late final dynamic createdBy;
//   late final dynamic modifiedOn;
//   late final dynamic modifiedBy;
//   late final dynamic syncStatus;
//   late final dynamic token;
//   late final dynamic companyCode;
//   late final dynamic companyName;
//   late final dynamic buCode;
//   late final dynamic buName;
//   late final dynamic plantCode;
//   late final dynamic plantName;
//   late final dynamic EmployeeImageUrl;

//   Login.fromJson(Map<String, dynamic> json) {
//     employeeId = json['employee_id'];
//     companyId = json['company_id'];
//     buId = json['bu_id'];
//     plantId = json['plant_id'];
//     userLevelId = json['user_level_id'];
//     employeeCode = json['employee_code'];
//     employeeName = json['employee_name'];
//     employeeType = json['employee_type'];
//     employeeImage = json['employee_image'];
//     mobileNo = json['mobile_no'];
//     email = json['email'];
//     designation = json['designation'];
//     isLogin = json['is_login'];
//     passwordLogin = json['password_login'];
//     status = json['status'];
//     lastlogin = json['lastlogin'];
//     isFirstPassword = json['is_first_password'];
//     createdOn = json['created_on'];
//     createdBy = json['created_by'];
//     modifiedOn = json['modified_on'];
//     modifiedBy = json['modified_by'];
//     syncStatus = json['sync_status'];
//     token = json['token'];
//     companyCode = json['company_code'];
//     companyName = json['company_name'];
//     buCode = json['bu_code'];
//     buName = json['bu_name'];
//     plantCode = json['plant_code'];
//     plantName = json['plant_name'];
//     EmployeeImageUrl = json['employee_image_url'];
//   }

//   Map<String, dynamic> toJson() {
//     final _data = <String, dynamic>{};
//     _data['employee_id'] = employeeId as int;
//     _data['company_id'] = companyId as String;
//     _data['bu_id'] = buId as String;
//     _data['plant_id'] = plantId as String;
//     _data['user_level_id'] = userLevelId as int;
//     _data['employee_code'] = employeeCode as String;
//     _data['employee_name'] = employeeName as String;
//     _data['employee_type'] = employeeType as String;
//     _data['employee_image'] = employeeImage as String;
//     _data['mobile_no'] = mobileNo as String;
//     _data['email'] = email as String;
//     _data['designation'] = designation as String;
//     _data['is_login'] = isLogin as String;
//     _data['password_login'] = passwordLogin as String;
//     _data['status'] = status as String;
//     _data['lastlogin'] = lastlogin as String;
//     _data['is_first_password'] = isFirstPassword as String;
//     _data['created_on'] = createdOn as String;
//     _data['created_by'] = createdBy as int;
//     _data['modified_on'] = modifiedOn as String;
//     _data['modified_by'] = modifiedBy as int;
//     _data['sync_status'] = syncStatus as String;
//     _data['token'] = token as int;
//     _data['company_code'] = companyCode as String;
//     _data['company_name'] = companyName as String;
//     _data['bu_code'] = buCode as String;
//     _data['bu_name'] = buName as String;
//     _data['plant_code'] = plantCode as String;
//     _data['plant_name'] = plantName as String;
//     _data['employee_image_url'] = EmployeeImageUrl as String;
//     return _data;
//   }
// }

class LoginModel {
  bool? isError;
  String? message;
  List<Data>? data;
  String? shield;

  LoginModel({this.isError, this.message, this.data, this.shield});

  LoginModel.fromJson(Map<String, dynamic> json) {
    isError = json['is_error'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    shield = json['shield'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['is_error'] = this.isError;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['shield'] = this.shield;
    return data;
  }
}

class Data {
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
  String? employeeImage;
  String? isLogin;
  String? status;
  String? createdOn;
  int? createdBy;
  String? modifiedOn;
  int? modifiedBy;
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
  String? userAvailability;
  List<int>? companyId;
  int? loginId;
  String? token;
  String? companyCode;
  String? companyName;
  String? buCode;
  String? buName;
  String? plantCode;
  String? plantName;
  String? departmentCode;
  String? departmentName;
  String? locationCode;
  String? locationName;
  String? employeeImageUrl;
  int? usersCount;
  String? isTrial;
  String? trialDate;

  Data(
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
      this.employeeImage,
      this.isLogin,
      this.status,
      this.createdOn,
      this.createdBy,
      this.modifiedOn,
      this.modifiedBy,
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
      this.userAvailability,
      this.companyId,
      this.loginId,
      this.token,
      this.companyCode,
      this.companyName,
      this.buCode,
      this.buName,
      this.plantCode,
      this.plantName,
      this.departmentCode,
      this.departmentName,
      this.locationCode,
      this.locationName,
      this.employeeImageUrl,
      this.usersCount,
      this.isTrial,
      this.trialDate});

  Data.fromJson(Map<String, dynamic> json) {
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
    employeeImage = json['employee_image'];
    isLogin = json['is_login'];
    status = json['status'];
    createdOn = json['created_on'];
    createdBy = json['created_by'];
    modifiedOn = json['modified_on'];
    modifiedBy = json['modified_by'];
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
    userAvailability = json['user_availability'];
    companyId = json['company_id'].cast<int>();
    loginId = json['login_id'];
    token = json['token'];
    companyCode = json['company_code'];
    companyName = json['company_name'];
    buCode = json['bu_code'];
    buName = json['bu_name'];
    plantCode = json['plant_code'];
    plantName = json['plant_name'];
    departmentCode = json['department_code'];
    departmentName = json['department_name'];
    locationCode = json['location_code'];
    locationName = json['location_name'];
    employeeImageUrl = json['employee_image_url'];
    usersCount = json['users_count'];
    isTrial = json['is_trial'];
    trialDate = json['trial_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['employee_id'] = this.employeeId;
    data['designation_id'] = this.designationId;
    data['employee_code'] = this.employeeCode;
    data['employee_name'] = this.employeeName;
    data['employee_type'] = this.employeeType;
    data['employee_email'] = this.employeeEmail;
    data['employee_mobile'] = this.employeeMobile;
    data['employee_skill'] = this.employeeSkill;
    data['employee_address'] = this.employeeAddress;
    data['user_name'] = this.userName;
    data['employee_image'] = this.employeeImage;
    data['is_login'] = this.isLogin;
    data['status'] = this.status;
    data['created_on'] = this.createdOn;
    data['created_by'] = this.createdBy;
    data['modified_on'] = this.modifiedOn;
    data['modified_by'] = this.modifiedBy;
    data['bu_id'] = this.buId;
    data['plant_id'] = this.plantId;
    data['department_id'] = this.departmentId;
    data['employee_gender'] = this.employeeGender;
    data['employee_level'] = this.employeeLevel;
    data['employee_reportee'] = this.employeeReportee;
    data['is_engineer'] = this.isEngineer;
    data['location_id'] = this.locationId;
    data['sub_user'] = this.subUser;
    data['is_assigned'] = this.isAssigned;
    data['user_availability'] = this.userAvailability;
    data['company_id'] = this.companyId;
    data['login_id'] = this.loginId;
    data['token'] = this.token;
    data['company_code'] = this.companyCode;
    data['company_name'] = this.companyName;
    data['bu_code'] = this.buCode;
    data['bu_name'] = this.buName;
    data['plant_code'] = this.plantCode;
    data['plant_name'] = this.plantName;
    data['department_code'] = this.departmentCode;
    data['department_name'] = this.departmentName;
    data['location_code'] = this.locationCode;
    data['location_name'] = this.locationName;
    data['employee_image_url'] = this.employeeImageUrl;
    data['users_count'] = this.usersCount;
    data['is_trial'] = this.isTrial;
    data['trial_date'] = this.trialDate;
    return data;
  }
}
