class AssetModel {
  bool? isError;
  String? message;
  String? assetId;
  List<AssetLists>? assetLists;
  List<AssetPartList>? assetPartLists;

  AssetModel({
    this.isError,
    this.message,
    this.assetId,
    this.assetLists,
    this.assetPartLists,
  });

  AssetModel.fromJson(Map<String, dynamic> json) {
    isError = json['is_error'];
    message = json['message'];
    assetId = json['asset_id'];
    if (json['assetLists'] != null) {
      assetLists = <AssetLists>[];
      json['assetLists'].forEach((v) {
        assetLists!.add(AssetLists.fromJson(v));
      });
    }
    if (json['asset_partLists'] != null) {
      assetPartLists = <AssetPartList>[];
      json['asset_partLists'].forEach((v) {
        assetPartLists!.add(AssetPartList.fromJson(v));
      });
    }
  }
  AssetModel.fromError(
      {required bool errorStatus, required String errorMessage}) {
    isError = errorStatus;
    message = errorMessage;
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['is_error'] = isError;
    data['message'] = message;
    data['asset_id'] = assetId;
    if (assetLists != null) {
      data['assetLists'] = assetLists!.map((v) => v.toJson()).toList();
    }
    if (assetPartLists != null) {
      data['asset_partLists'] = assetPartLists!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AssetLists {
  int? assetId;
  int? assetGroupId;
  String? assetCode;
  String? assetName;
  String? assetSerialNo;
  String? assetMake;
  int? assetManageablePerson;
  int? assetResponsiblePerson;
  String? assetManufacturer;
  String? assetMfgDate;
  String? assetVendorName;
  String? assetVendorMailId;
  String? assetVendorContact;
  String? assetImage;
  String? assetManual;
  String? assetVideo;
  String? status;
  String? createdOn;
  int? createdBy;
  String? modifiedOn;
  int? modifiedBy;
  int? companyId;
  int? buId;
  int? plantId;
  int? departmentId;
  int? locationId;
  int? assetModelId;
  List<int>? assetResponsibleHead;
  String? assetImageUrl;
  String? assetManualUrl;
  String? assetVideoUrl;
  String? createdUser;
  String? modifiedUser;
  String? manageablePerson;
  String? responsiblePerson;
  String? responsibleHead;
  String? company;
  String? bu;
  String? plant;
  String? department;
  String? location;
  String? assetGroup;

  AssetLists({
    this.assetId,
    this.assetGroupId,
    this.assetCode,
    this.assetName,
    this.assetSerialNo,
    this.assetMake,
    this.assetManageablePerson,
    this.assetResponsiblePerson,
    this.assetManufacturer,
    this.assetMfgDate,
    this.assetVendorName,
    this.assetVendorMailId,
    this.assetVendorContact,
    this.assetImage,
    this.assetManual,
    this.assetVideo,
    this.status,
    this.createdOn,
    this.createdBy,
    this.modifiedOn,
    this.modifiedBy,
    this.companyId,
    this.buId,
    this.plantId,
    this.departmentId,
    this.locationId,
    this.assetModelId,
    this.assetResponsibleHead,
    this.assetImageUrl,
    this.assetManualUrl,
    this.assetVideoUrl,
    this.createdUser,
    this.modifiedUser,
    this.manageablePerson,
    this.responsiblePerson,
    this.responsibleHead,
    this.company,
    this.bu,
    this.plant,
    this.department,
    this.location,
    this.assetGroup,
  });

  AssetLists.fromJson(Map<String, dynamic> json) {
    assetId = json['asset_id'];
    assetGroupId = json['asset_group_id'];
    assetCode = json['asset_code'];
    assetName = json['asset_name'];
    assetSerialNo = json['asset_serial_no'];
    assetMake = json['asset_make'];
    assetManageablePerson = json['asset_manageable_person'];
    assetResponsiblePerson = json['asset_responsible_person'];
    assetManufacturer = json['asset_manufacturer'];
    assetMfgDate = json['asset_mfg_date'];
    assetVendorName = json['asset_vendor_name'];
    assetVendorMailId = json['asset_vendor_mail_id'];
    assetVendorContact = json['asset_vendor_contact'];
    assetImage = json['asset_image'];
    assetManual = json['asset_manual'];
    assetVideo = json['asset_video'];
    status = json['status'];
    createdOn = json['created_on'];
    createdBy = json['created_by'];
    modifiedOn = json['modified_on'];
    modifiedBy = json['modified_by'];
    companyId = json['company_id'];
    buId = json['bu_id'];
    plantId = json['plant_id'];
    departmentId = json['department_id'];
    locationId = json['location_id'];
    assetModelId = json['asset_model_id'];
    assetResponsibleHead = json['asset_responsible_head'].cast<int>();
    assetImageUrl = json['asset_image_url'];
    assetManualUrl = json['asset_manual_url'];
    assetVideoUrl = json['asset_video_url'];
    createdUser = json['created_user'];
    modifiedUser = json['modified_user'];
    manageablePerson = json['manageable_person'];
    responsiblePerson = json['responsible_person'];
    responsibleHead = json['responsible_head'];
    company = json['company'];
    bu = json['bu'];
    plant = json['plant'];
    department = json['department'];
    location = json['location'];
    assetGroup = json['asset_group'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['asset_id'] = assetId;
    data['asset_group_id'] = assetGroupId;
    data['asset_code'] = assetCode;
    data['asset_name'] = assetName;
    data['asset_serial_no'] = assetSerialNo;
    data['asset_make'] = assetMake;
    data['asset_manageable_person'] = assetManageablePerson;
    data['asset_responsible_person'] = assetResponsiblePerson;
    data['asset_manufacturer'] = assetManufacturer;
    data['asset_mfg_date'] = assetMfgDate;
    data['asset_vendor_name'] = assetVendorName;
    data['asset_vendor_mail_id'] = assetVendorMailId;
    data['asset_vendor_contact'] = assetVendorContact;
    data['asset_image'] = assetImage;
    data['asset_manual'] = assetManual;
    data['asset_video'] = assetVideo;
    data['status'] = status;
    data['created_on'] = createdOn;
    data['created_by'] = createdBy;
    data['modified_on'] = modifiedOn;
    data['modified_by'] = modifiedBy;
    data['company_id'] = companyId;
    data['bu_id'] = buId;
    data['plant_id'] = plantId;
    data['department_id'] = departmentId;
    data['location_id'] = locationId;
    data['asset_model_id'] = assetModelId;
    data['asset_responsible_head'] = assetResponsibleHead;
    data['asset_image_url'] = assetImageUrl;
    data['asset_manual_url'] = assetManualUrl;
    data['asset_video_url'] = assetVideoUrl;
    data['created_user'] = createdUser;
    data['modified_user'] = modifiedUser;
    data['manageable_person'] = manageablePerson;
    data['responsible_person'] = responsiblePerson;
    data['responsible_head'] = responsibleHead;
    data['company'] = company;
    data['bu'] = bu;
    data['plant'] = plant;
    data['department'] = department;
    data['location'] = location;
    data['asset_group'] = assetGroup;
    return data;
  }
}

// Assuming a similar class for AssetPartList
class AssetPartList {
  int? partId;
  String? partName;
  String? partSerialNo;

  AssetPartList({
    this.partId,
    this.partName,
    this.partSerialNo,
  });

  AssetPartList.fromJson(Map<String, dynamic> json) {
    partId = json['part_id'];
    partName = json['part_name'];
    partSerialNo = json['part_serial_no'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['part_id'] = partId;
    data['part_name'] = partName;
    data['part_serial_no'] = partSerialNo;
    return data;
  }
}
