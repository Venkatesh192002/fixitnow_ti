import 'dart:convert';

class EmployeeListModel {
  final bool? isError;
  final String? message;
  final String? employeeId;
  final List<EmployeeList>? employeeLists;

  EmployeeListModel({
    this.isError,
    this.message,
    this.employeeId,
    this.employeeLists,
  });

  // Factory constructor for creating an error instance
  factory EmployeeListModel.fromError(String errorMessage) => EmployeeListModel(
        isError: true,
        message: errorMessage,
        employeeLists: [],
      );

  factory EmployeeListModel.fromRawJson(String str) =>
      EmployeeListModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory EmployeeListModel.fromJson(Map<String, dynamic> json) =>
      EmployeeListModel(
        isError: json["is_error"],
        message: json["message"],
        employeeId: json["employee_id"],
        employeeLists: json["employeeLists"] == null
            ? []
            : List<EmployeeList>.from(
                json["employeeLists"]!.map((x) => EmployeeList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "is_error": isError,
        "message": message,
        "employee_id": employeeId,
        "employeeLists": employeeLists == null
            ? []
            : List<dynamic>.from(employeeLists!.map((x) => x.toJson())),
      };
}

class EmployeeList {
  final int? employeeId;
  final int? designationId;
  final String? employeeCode;
  final String? employeeName;
  final String? employeeType; // Changed from enum to String
  final String? employeeEmail; // Changed from enum to String
  final String? employeeMobile;
  final String? employeeSkill; // Changed from enum to String
  final String? employeeAddress;
  final String? userName;
  final String? passwordLogin; // Changed from enum to String
  final String? employeeImage; // Changed from enum to String
  final String? isLogin; // Changed from enum to String
  final String? status; // Changed from enum to String
  final DateTime? createdOn;
  final int? createdBy;
  final String? modifiedOn;
  final int? modifiedBy;
  final int? buId;
  final int? plantId;
  final int? departmentId;
  final String? employeeGender; // Changed from enum to String
  final int? employeeLevel;
  final int? employeeReportee;
  final String? isEngineer; // Changed from enum to String
  final int? locationId;
  final int? subUser;
  final String? isAssigned; // Changed from enum to String
  final String? userAvailability; // Changed from enum to String
  final List<int>? companyId;
  final String? employeeImageUrl;
  final String? createdUser; // Changed from enum to String
  final String? modifiedUser; // Changed from enum to String
  final String? bu; // Changed from enum to String
  final String? plant; // Changed from enum to String
  final String? department; // Changed from enum to String
  final String? designation; // Changed from enum to String
  final List<String>? company; // Changed from enum to String

  EmployeeList({
    this.employeeId,
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
    this.employeeImageUrl,
    this.createdUser,
    this.modifiedUser,
    this.bu,
    this.plant,
    this.department,
    this.designation,
    this.company,
  });

  factory EmployeeList.fromRawJson(String str) =>
      EmployeeList.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory EmployeeList.fromJson(Map<String, dynamic> json) => EmployeeList(
        employeeId: json["employee_id"],
        designationId: json["designation_id"],
        employeeCode: json["employee_code"],
        employeeName: json["employee_name"],
        employeeType: json["employee_type"],
        employeeEmail: json["employee_email"],
        employeeMobile: json["employee_mobile"],
        employeeSkill: json["employee_skill"],
        employeeAddress: json["employee_address"],
        userName: json["user_name"],
        passwordLogin: json["password_login"],
        employeeImage: json["employee_image"],
        isLogin: json["is_login"],
        status: json["status"],
        createdOn: json["created_on"] == null
            ? null
            : DateTime.parse(json["created_on"]),
        createdBy: json["created_by"],
        modifiedOn: json["modified_on"],
        modifiedBy: json["modified_by"],
        buId: json["bu_id"],
        plantId: json["plant_id"],
        departmentId: json["department_id"],
        employeeGender: json["employee_gender"],
        employeeLevel: json["employee_level"],
        employeeReportee: json["employee_reportee"],
        isEngineer: json["is_engineer"],
        locationId: json["location_id"],
        subUser: json["sub_user"],
        isAssigned: json["is_assigned"],
        userAvailability: json["user_availability"],
        companyId: json["company_id"] == null
            ? []
            : List<int>.from(json["company_id"]!.map((x) => x)),
        employeeImageUrl: json["employee_image_url"],
        createdUser: json["created_user"],
        modifiedUser: json["modified_user"],
        bu: json["bu"],
        plant: json["plant"],
        department: json["department"],
        designation: json["designation"],
        company: json["company"] == null
            ? []
            : List<String>.from(json["company"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "employee_id": employeeId,
        "designation_id": designationId,
        "employee_code": employeeCode,
        "employee_name": employeeName,
        "employee_type": employeeType,
        "employee_email": employeeEmail,
        "employee_mobile": employeeMobile,
        "employee_skill": employeeSkill,
        "employee_address": employeeAddress,
        "user_name": userName,
        "password_login": passwordLogin,
        "employee_image": employeeImage,
        "is_login": isLogin,
        "status": status,
        "created_on": createdOn?.toIso8601String(),
        "created_by": createdBy,
        "modified_on": modifiedOn,
        "modified_by": modifiedBy,
        "bu_id": buId,
        "plant_id": plantId,
        "department_id": departmentId,
        "employee_gender": employeeGender,
        "employee_level": employeeLevel,
        "employee_reportee": employeeReportee,
        "is_engineer": isEngineer,
        "location_id": locationId,
        "sub_user": subUser,
        "is_assigned": isAssigned,
        "user_availability": userAvailability,
        "company_id": companyId == null
            ? []
            : List<dynamic>.from(companyId!.map((x) => x)),
        "employee_image_url": employeeImageUrl,
        "created_user": createdUser,
        "modified_user": modifiedUser,
        "bu": bu,
        "plant": plant,
        "department": department,
        "designation": designation,
        "company":
            company == null ? [] : List<dynamic>.from(company!.map((x) => x)),
      };
}
