class SubCategoryModel {
  bool? isError;
  String? message;
  List<BreakdownCategoryLists>? breakdownCategoryLists;

  SubCategoryModel({this.isError, this.message, this.breakdownCategoryLists});

  SubCategoryModel.fromJson(Map<String, dynamic> json) {
    isError = json['is_error'];
    message = json['message'];
    if (json['breakdown_categoryLists'] != null) {
      breakdownCategoryLists = <BreakdownCategoryLists>[];
      json['breakdown_categoryLists'].forEach((v) {
        breakdownCategoryLists!.add(BreakdownCategoryLists.fromJson(v));
      });
    }
  }

  SubCategoryModel.fromError(
      {required bool errorStatus, required String errorMessage}) {
    isError = errorStatus;
    message = errorMessage;
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['is_error'] = isError;
    data['message'] = message;
    if (breakdownCategoryLists != null) {
      data['breakdown_categoryLists'] =
          breakdownCategoryLists!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BreakdownCategoryLists {
  int? breakdownAssignmentId;
  int? companyId;
  int? buId;
  int? plantId;
  int? assetGroupId;
  int? breakdownCategoryId;
  String? createdOn;
  int? createdBy;
  String? modifiedOn;
  int? modifiedBy;
  String? status;
  int? breakdownSubCategoryId;
  int? escalationTime;
  String? companyName;
  String? buName;
  String? plantName;
  String? assetGroupName;
  String? createdUser;
  String? modifiedUser;
  String? breakdownCategory;
  String? breakdownSubCategory;

  BreakdownCategoryLists(
      {this.breakdownAssignmentId,
      this.companyId,
      this.buId,
      this.plantId,
      this.assetGroupId,
      this.breakdownCategoryId,
      this.createdOn,
      this.createdBy,
      this.modifiedOn,
      this.modifiedBy,
      this.status,
      this.breakdownSubCategoryId,
      this.escalationTime,
      this.companyName,
      this.buName,
      this.plantName,
      this.assetGroupName,
      this.createdUser,
      this.modifiedUser,
      this.breakdownCategory,
      this.breakdownSubCategory});

  BreakdownCategoryLists.fromJson(Map<String, dynamic> json) {
    breakdownAssignmentId = json['breakdown_assignment_id'];
    companyId = json['company_id'];
    buId = json['bu_id'];
    plantId = json['plant_id'];
    assetGroupId = json['asset_group_id'];
    breakdownCategoryId = json['breakdown_category_id'];
    createdOn = json['created_on'];
    createdBy = json['created_by'];
    modifiedOn = json['modified_on'];
    modifiedBy = json['modified_by'];
    status = json['status'];
    breakdownSubCategoryId = json['breakdown_sub_category_id'];
    escalationTime = json['escalation_time'];
    companyName = json['company_name'];
    buName = json['bu_name'];
    plantName = json['plant_name'];
    assetGroupName = json['asset_group_name'];
    createdUser = json['created_user'];
    modifiedUser = json['modified_user'];
    breakdownCategory = json['breakdown_category'];
    breakdownSubCategory = json['breakdown_sub_category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['breakdown_assignment_id'] = breakdownAssignmentId;
    data['company_id'] = companyId;
    data['bu_id'] = buId;
    data['plant_id'] = plantId;
    data['asset_group_id'] = assetGroupId;
    data['breakdown_category_id'] = breakdownCategoryId;
    data['created_on'] = createdOn;
    data['created_by'] = createdBy;
    data['modified_on'] = modifiedOn;
    data['modified_by'] = modifiedBy;
    data['status'] = status;
    data['breakdown_sub_category_id'] = breakdownSubCategoryId;
    data['escalation_time'] = escalationTime;
    data['company_name'] = companyName;
    data['bu_name'] = buName;
    data['plant_name'] = plantName;
    data['asset_group_name'] = assetGroupName;
    data['created_user'] = createdUser;
    data['modified_user'] = modifiedUser;
    data['breakdown_category'] = breakdownCategory;
    data['breakdown_sub_category'] = breakdownSubCategory;
    return data;
  }
}
