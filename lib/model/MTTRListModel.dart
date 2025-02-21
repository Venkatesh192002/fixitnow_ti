class MTTRListModel {
  bool? isError;
  String? message;
  List<MttrLists>? mttrLists;

  MTTRListModel({this.isError, this.message, this.mttrLists});

  MTTRListModel.fromJson(Map<String, dynamic> json) {
    isError = json['is_error'];
    message = json['message'];
    if (json['mttr_Lists'] != null) {
      mttrLists = <MttrLists>[];
      json['mttr_Lists'].forEach((v) {
        mttrLists!.add(MttrLists.fromJson(v));
      });
    }
  }
  MTTRListModel.fromError(
      {required bool isErrorThrown, required String errorMessage}) {
    isError = isErrorThrown;
    message = errorMessage;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['is_error'] = isError;
    data['message'] = message;
    if (mttrLists != null) {
      data['mttr_Lists'] = mttrLists!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MttrLists {
  int? mttrId;
  String? mttrCode;
  String? mttrName;

  MttrLists({this.mttrId, this.mttrCode, this.mttrName});

  MttrLists.fromJson(Map<String, dynamic> json) {
    mttrId = json['mttr_id'];
    mttrCode = json['mttr_code'];
    mttrName = json['mttr_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mttr_id'] = mttrId;
    data['mttr_code'] = mttrCode;
    data['mttr_name'] = mttrName;
    return data;
  }
}
