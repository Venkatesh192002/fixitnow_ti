class AssetHeadIdModel {
  bool? isError;
  String? message;
  List<AssignDepartmentHead>? assignDepartmentHead;

  AssetHeadIdModel({this.isError, this.message, this.assignDepartmentHead});

  AssetHeadIdModel.fromJson(Map<String, dynamic> json) {
    isError = json['is_error'];
    message = json['message'];
    if (json['assign_department_head'] != null) {
      assignDepartmentHead = <AssignDepartmentHead>[];
      json['assign_department_head'].forEach((v) {
        assignDepartmentHead!.add(new AssignDepartmentHead.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['is_error'] = this.isError;
    data['message'] = this.message;
    if (this.assignDepartmentHead != null) {
      data['assign_department_head'] =
          this.assignDepartmentHead!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AssignDepartmentHead {
  int? departmentId;
  String? departmentName;
  String? departmentCode;

  AssignDepartmentHead(
      {this.departmentId, this.departmentName, this.departmentCode});

  AssignDepartmentHead.fromJson(Map<String, dynamic> json) {
    departmentId = json['department_id'];
    departmentName = json['department_name'];
    departmentCode = json['department_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['department_id'] = this.departmentId;
    data['department_name'] = this.departmentName;
    data['department_code'] = this.departmentCode;
    return data;
  }
}