class AssetGroupModel {
  bool? isError;
  String? message;
  String? assetGroupId;
  List<AssetGroupLists>? assetGroupLists;

  AssetGroupModel(
      {this.isError, this.message, this.assetGroupId, this.assetGroupLists});

  AssetGroupModel.fromJson(Map<String, dynamic> json) {
    isError = json['is_error'];
    message = json['message'];
    assetGroupId = json['asset_group_id'];
    if (json['asset_groupLists'] != null) {
      assetGroupLists = <AssetGroupLists>[];
      json['asset_groupLists'].forEach((v) {
        assetGroupLists!.add(AssetGroupLists.fromJson(v));
      });
    }
  }
  AssetGroupModel.fromError(
      {required bool errorStatus, required String errorMessage}) {
    isError = errorStatus;
    message = errorMessage;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['is_error'] = isError;
    data['message'] = message;
    data['asset_group_id'] = assetGroupId;
    if (assetGroupLists != null) {
      data['asset_groupLists'] =
          assetGroupLists!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AssetGroupLists {
  int? assetGroupId;
  int? companyId;
  int? buId;
  int? plantId;
  int? departmentId;
  String? assetGroupCode;
  String? assetGroupName;
  String? status;
  String? createdOn;
  int? createdBy;
  String? modifiedOn;
  int? modifiedBy;
  int? locationId;
  String? isAssigned;
  String? company;
  String? bu;
  String? plant;
  String? department;
  String? location;
  String? createdUser;
  String? modifiedUser;

  AssetGroupLists(
      {this.assetGroupId,
      this.companyId,
      this.buId,
      this.plantId,
      this.departmentId,
      this.assetGroupCode,
      this.assetGroupName,
      this.status,
      this.createdOn,
      this.createdBy,
      this.modifiedOn,
      this.modifiedBy,
      this.locationId,
      this.isAssigned,
      this.company,
      this.bu,
      this.plant,
      this.department,
      this.location,
      this.createdUser,
      this.modifiedUser});

  AssetGroupLists.fromJson(Map<String, dynamic> json) {
    assetGroupId = json['asset_group_id'];
    companyId = json['company_id'];
    buId = json['bu_id'];
    plantId = json['plant_id'];
    departmentId = json['department_id'];
    assetGroupCode = json['asset_group_code'];
    assetGroupName = json['asset_group_name'];
    status = json['status'];
    createdOn = json['created_on'];
    createdBy = json['created_by'];
    modifiedOn = json['modified_on'];
    modifiedBy = json['modified_by'];
    locationId = json['location_id'];
    isAssigned = json['is_assigned'];
    company = json['company'];
    bu = json['bu'];
    plant = json['plant'];
    department = json['department'];
    location = json['location'];
    createdUser = json['created_user'];
    modifiedUser = json['modified_user'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['asset_group_id'] = assetGroupId;
    data['company_id'] = companyId;
    data['bu_id'] = buId;
    data['plant_id'] = plantId;
    data['department_id'] = departmentId;
    data['asset_group_code'] = assetGroupCode;
    data['asset_group_name'] = assetGroupName;
    data['status'] = status;
    data['created_on'] = createdOn;
    data['created_by'] = createdBy;
    data['modified_on'] = modifiedOn;
    data['modified_by'] = modifiedBy;
    data['location_id'] = locationId;
    data['is_assigned'] = isAssigned;
    data['company'] = company;
    data['bu'] = bu;
    data['plant'] = plant;
    data['department'] = department;
    data['location'] = location;
    data['created_user'] = createdUser;
    data['modified_user'] = modifiedUser;
    return data;
  }
}
