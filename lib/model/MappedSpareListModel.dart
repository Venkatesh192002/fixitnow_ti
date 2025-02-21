class MappedSpareListsModel {
  bool? isError;
  String? message;
  List<MappedSparesLists>? sparesLists;

  MappedSpareListsModel({this.isError, this.message, this.sparesLists});

  MappedSpareListsModel.fromJson(Map<String, dynamic> json) {
    isError = json['is_error'];
    message = json['message'];
    if (json['spares_lists'] != null) {
      sparesLists = <MappedSparesLists>[];
      json['spares_lists'].forEach((v) {
        sparesLists!.add(MappedSparesLists.fromJson(v));
      });
    }
  }
  MappedSpareListsModel.fromError(
      {required bool isErrorThrown, required String errorMessage}) {
    isError = isErrorThrown;
    message = errorMessage;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['is_error'] = isError;
    data['message'] = message;
    if (sparesLists != null) {
      data['spares_lists'] = sparesLists!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MappedSparesLists {
  String? assetGroupName;
  String? assetName;
  int? spareId;
  String? spareCode;
  String? spareName;
  int? spareLocation;
  String? isChecked;
  int? spareStock;
  int? spareMinQty;
  int? spareUnitPrice;
  String? type;

  MappedSparesLists(
      {this.assetGroupName,
      this.assetName,
      this.spareId,
      this.spareCode,
      this.spareName,
      this.spareLocation,
      this.isChecked,
      this.spareStock,
      this.spareMinQty,
      this.spareUnitPrice,
      this.type});

  MappedSparesLists.fromJson(Map<String, dynamic> json) {
    assetGroupName = json['asset_group_name'];
    assetName = json['asset_name'];
    spareId = json['spare_id'];
    spareCode = json['spare_code'];
    spareName = json['spare_name'];
    spareLocation = json['spare_location'];
    isChecked = json['is_checked'];
    spareStock = json['spare_stock'];
    spareMinQty = json['spare_min_qty'];
    spareUnitPrice = json['spare_unit_price'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['asset_group_name'] = assetGroupName;
    data['asset_name'] = assetName;
    data['spare_id'] = spareId;
    data['spare_code'] = spareCode;
    data['spare_name'] = spareName;
    data['spare_location'] = spareLocation;
    data['is_checked'] = isChecked;
    data['spare_stock'] = spareStock;
    data['spare_min_qty'] = spareMinQty;
    data['spare_unit_price'] = spareUnitPrice;
    data['type'] = type;
    return data;
  }
}
