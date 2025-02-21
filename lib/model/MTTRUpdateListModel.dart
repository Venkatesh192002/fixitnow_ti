class MTTRUpdateListModel {
  bool? isError;
  String? message;
  List<MttrData>? mttrData;

  MTTRUpdateListModel({this.isError, this.message, this.mttrData});

  MTTRUpdateListModel.fromJson(Map<String, dynamic> json) {
    isError = json['is_error'];
    message = json['message'];
    if (json['mttr_data'] != null) {
      mttrData = <MttrData>[];
      json['mttr_data'].forEach((v) {
        mttrData!.add(MttrData.fromJson(v));
      });
    }
  }
  MTTRUpdateListModel.fromError(
      {required bool isErrorThrown, required String errorMessage}) {
    isError = isErrorThrown;
    message = errorMessage;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['is_error'] = isError;
    data['message'] = message;
    if (mttrData != null) {
      data['mttr_data'] = mttrData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MttrData {
  int? mttrId;
  String? mttrName;
  double? mttrValue;

  MttrData({this.mttrId, this.mttrName, this.mttrValue});

  MttrData.fromJson(Map<String, dynamic> json) {
    mttrId = json['mttr_id'];
    mttrName = json['mttr_name'];
    mttrValue = json['mttr_value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mttr_id'] = mttrId;
    data['mttr_name'] = mttrName;
    data['mttr_value'] = mttrValue;
    return data;
  }
}
