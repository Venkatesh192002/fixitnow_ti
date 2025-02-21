class MainCategoryModel {
  bool? isError;
  String? message;
  String? breakdownCategoryId;
  List<MainBreakdownCategoryLists>? breakdownCategoryLists;

  MainCategoryModel(
      {this.isError,
      this.message,
      this.breakdownCategoryId,
      this.breakdownCategoryLists});

  MainCategoryModel.fromJson(Map<String, dynamic> json) {
    isError = json['is_error'];
    message = json['message'];
    breakdownCategoryId = json['breakdown_category_id'];
    if (json['breakdown_categoryLists'] != null) {
      breakdownCategoryLists = <MainBreakdownCategoryLists>[];
      json['breakdown_categoryLists'].forEach((v) {
        breakdownCategoryLists!.add(MainBreakdownCategoryLists.fromJson(v));
      });
    }
  }
  MainCategoryModel.fromError(
      {required bool errorStatus, required String errorMessage}) {
    isError = errorStatus;
    message = errorMessage;
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['is_error'] = isError;
    data['message'] = message;
    data['breakdown_category_id'] = breakdownCategoryId;
    if (breakdownCategoryLists != null) {
      data['breakdown_categoryLists'] =
          breakdownCategoryLists!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MainBreakdownCategoryLists {
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
  String? isAssigned;
  String? companyName;
  String? buName;
  String? plantName;
  String? departmentName;
  String? assetGroupName;
  String? createdUser;
  String? modifiedUser;

  MainBreakdownCategoryLists(
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
      this.modifiedBy,
      this.isAssigned,
      this.companyName,
      this.buName,
      this.plantName,
      this.departmentName,
      this.assetGroupName,
      this.createdUser,
      this.modifiedUser});

  MainBreakdownCategoryLists.fromJson(Map<String, dynamic> json) {
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
    isAssigned = json['is_assigned'];
    companyName = json['company_name'];
    buName = json['bu_name'];
    plantName = json['plant_name'];
    departmentName = json['department_name'];
    assetGroupName = json['asset_group_name'];
    createdUser = json['created_user'];
    modifiedUser = json['modified_user'];
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
    data['is_assigned'] = isAssigned;
    data['company_name'] = companyName;
    data['bu_name'] = buName;
    data['plant_name'] = plantName;
    data['department_name'] = departmentName;
    data['asset_group_name'] = assetGroupName;
    data['created_user'] = createdUser;
    data['modified_user'] = modifiedUser;
    return data;
  }
}
