class IssueSpinnerModel {
  bool? isError;
  String? message;
  List<IssueLists>? issueLists;

  IssueSpinnerModel({this.isError, this.message, this.issueLists});

  IssueSpinnerModel.fromJson(Map<String, dynamic> json) {
    isError = json['is_error'];
    message = json['message'];
    if (json['Issue_Lists'] != null) {
      issueLists = <IssueLists>[];
      json['Issue_Lists'].forEach((v) {
        issueLists!.add(IssueLists.fromJson(v));
      });
    }
  }

  IssueSpinnerModel.fromError({required bool isErrorThrown,required String errorMessage}){
    isError = isErrorThrown;
    message = errorMessage;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['is_error'] = isError;
    data['message'] = message;
    if (issueLists != null) {
      data['Issue_Lists'] = issueLists!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class IssueLists {
  int? breakdownCategoryId;
  int? companyId;
  int? buId;
  int? plantId;
  int? departmentId;
  int? assetGroupId;
  String? breakdownCategoryCode;
  String? breakdownCategoryName;
  String? breakdownCategoryImage;
  String? status;
  String? createdOn;
  int? createdBy;
  String? modifiedOn;
  int? modifiedBy;

  IssueLists(
      {this.breakdownCategoryId,
      this.companyId,
      this.buId,
      this.plantId,
      this.departmentId,
      this.assetGroupId,
      this.breakdownCategoryCode,
      this.breakdownCategoryName,
      this.breakdownCategoryImage,
      this.status,
      this.createdOn,
      this.createdBy,
      this.modifiedOn,
      this.modifiedBy});

  IssueLists.fromJson(Map<String, dynamic> json) {
    breakdownCategoryId = json['breakdown_category_id'];
    companyId = json['company_id'];
    buId = json['bu_id'];
    plantId = json['plant_id'];
    departmentId = json['department_id'];
    assetGroupId = json['asset_group_id'];
    breakdownCategoryCode = json['breakdown_category_code'];
    breakdownCategoryName = json['breakdown_category_name'];
    breakdownCategoryImage = json['breakdown_category_image'];
    status = json['status'];
    createdOn = json['created_on'];
    createdBy = json['created_by'];
    modifiedOn = json['modified_on'];
    modifiedBy = json['modified_by'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['breakdown_category_id'] = breakdownCategoryId;
    data['company_id'] = companyId;
    data['bu_id'] = buId;
    data['plant_id'] = plantId;
    data['department_id'] = departmentId;
    data['asset_group_id'] = assetGroupId;
    data['breakdown_category_code'] = breakdownCategoryCode;
    data['breakdown_category_name'] = breakdownCategoryName;
    data['breakdown_category_image'] = breakdownCategoryImage;
    data['status'] = status;
    data['created_on'] = createdOn;
    data['created_by'] = createdBy;
    data['modified_on'] = modifiedOn;
    data['modified_by'] = modifiedBy;
    return data;
  }
}
