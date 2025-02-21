class SpareListsModel {
  bool? isError;
  String? message;
  List<SparesLists>? sparesLists;

  SpareListsModel({this.isError, this.message, this.sparesLists});

  SpareListsModel.fromJson(Map<String, dynamic> json) {
    isError = json['is_error'];
    message = json['message'];
    if (json['spares_lists'] != null) {
      sparesLists = <SparesLists>[];
      json['spares_lists'].forEach((v) {
        sparesLists!.add(SparesLists.fromJson(v));
      });
    }
  }
  SpareListsModel.fromError({
    required bool isErrorThrown,
    required String errorMessage,
  })  : isError = isErrorThrown,
        message = errorMessage,
        sparesLists = [];

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

class SparesLists {
  String? plantName;
  String? plantCode;
  int? spareId;
  String? spareCode;
  String? spareName;
  String? spareLocation;
  String? isChecked;
  int? spareStock;
  int? spareMinQty;
  int? spareUnitPrice;
  String? type;

  SparesLists(
      {this.plantName,
      this.plantCode,
      this.spareId,
      this.spareCode,
      this.spareName,
      this.spareLocation,
      this.isChecked,
      this.spareStock,
      this.spareMinQty,
      this.spareUnitPrice,
      this.type});

  SparesLists.fromJson(Map<String, dynamic> json) {
    plantName = json['plant_name'];
    plantCode = json['plant_code'];
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
    data['plant_name'] = plantName;
    data['plant_code'] = plantCode;
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
