class CategoryBasedModel {
  bool? isError;
  String? message;
  List<CategoryBreakdownReportLists>? breakdownReportLists;

  CategoryBasedModel({this.isError, this.message, this.breakdownReportLists});

  CategoryBasedModel.fromJson(Map<String, dynamic> json) {
    isError = json['is_error'];
    message = json['message'];
    if (json['breakdown_reportLists'] != null) {
      breakdownReportLists = <CategoryBreakdownReportLists>[];
      json['breakdown_reportLists'].forEach((v) {
        breakdownReportLists!.add(CategoryBreakdownReportLists.fromJson(v));
      });
    }
  }
  CategoryBasedModel.fromError(
      {required bool errorStatus, required String errorMessage}) {
    isError = errorStatus;
    message = errorMessage;
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['is_error'] = isError;
    data['message'] = message;
    if (breakdownReportLists != null) {
      data['breakdown_reportLists'] =
          breakdownReportLists!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CategoryBreakdownReportLists {
  int? ticketCount;
  int? assetCount;
  int? sumOfDowntime;
  int? open;
  int? assign;
  int? accept;
  int? reject;
  int? reassign;
  int? checkIn;
  int? onHold;
  int? pending;
  int? completed;
  int? fixed;
  int? reopen;
  int? cancel;
  int? delete;
  int? inProgressTickets;
  double? mtbf;
  double? mttr;
  String? companyCode;
  String? companyName;
  String? buCode;
  String? buName;
  String? plantCode;
  String? plantName;
  String? departmentCode;
  String? departmentName;
  String? locationCode;
  String? locationName;
  String? assetGroupCode;
  String? assetGroupName;
  String? assetCode;
  String? assetName;
  String? breakdownCategoryCode;
  String? breakdownCategoryName;
  String? breakdownSubCategoryCode;
  String? breakdownSubCategoryName;
  String? assetModelName;
  int? companyId;
  int? buId;
  int? plantId;
  int? departmentId;
  int? locationId;
  int? assetGroupId;
  int? assetId;
  int? breakdownCategoryId;
  int? breakdownSubCategoryId;

  CategoryBreakdownReportLists(
      {this.ticketCount,
      this.assetCount,
      this.sumOfDowntime,
      this.open,
      this.assign,
      this.accept,
      this.reject,
      this.reassign,
      this.checkIn,
      this.onHold,
      this.pending,
      this.completed,
      this.fixed,
      this.reopen,
      this.cancel,
      this.delete,
      this.inProgressTickets,
      this.mtbf,
      this.mttr,
      this.companyCode,
      this.companyName,
      this.buCode,
      this.buName,
      this.plantCode,
      this.plantName,
      this.departmentCode,
      this.departmentName,
      this.locationCode,
      this.locationName,
      this.assetGroupCode,
      this.assetGroupName,
      this.assetCode,
      this.assetName,
      this.breakdownCategoryCode,
      this.breakdownCategoryName,
      this.breakdownSubCategoryCode,
      this.breakdownSubCategoryName,
      this.assetModelName,
      this.companyId,
      this.buId,
      this.plantId,
      this.departmentId,
      this.locationId,
      this.assetGroupId,
      this.assetId,
      this.breakdownCategoryId,
      this.breakdownSubCategoryId});

  CategoryBreakdownReportLists.fromJson(Map<String, dynamic> json) {
    ticketCount = json['ticket_count'];
    assetCount = json['asset_count'];
    sumOfDowntime = json['sum_of_downtime'];
    open = json['open'];
    assign = json['assign'];
    accept = json['accept'];
    reject = json['reject'];
    reassign = json['reassign'];
    checkIn = json['check_in'];
    onHold = json['on_hold'];
    pending = json['pending'];
    completed = json['completed'];
    fixed = json['fixed'];
    reopen = json['reopen'];
    cancel = json['cancel'];
    delete = json['delete'];
    inProgressTickets = json['in_progress_tickets'];
    mtbf = json['mtbf'] != null
        ? (json['mtbf'] is int
            ? (json['mtbf'] as int).toDouble()
            : json['mtbf'])
        : null;
    mttr = json['mttr'] != null
        ? (json['mttr'] is int
            ? (json['mttr'] as int).toDouble()
            : json['mttr'])
        : null;
    companyCode = json['company_code'];
    companyName = json['company_name'];
    buCode = json['bu_code'];
    buName = json['bu_name'];
    plantCode = json['plant_code'];
    plantName = json['plant_name'];
    departmentCode = json['department_code'];
    departmentName = json['department_name'];
    locationCode = json['location_code'];
    locationName = json['location_name'];
    assetGroupCode = json['asset_group_code'];
    assetGroupName = json['asset_group_name'];
    assetCode = json['asset_code'];
    assetName = json['asset_name'];
    breakdownCategoryCode = json['breakdown_category_code'];
    breakdownCategoryName = json['breakdown_category_name'];
    breakdownSubCategoryCode = json['breakdown_sub_category_code'];
    breakdownSubCategoryName = json['breakdown_sub_category_name'];
    assetModelName = json['asset_model_name'];
    companyId = json['company_id'];
    buId = json['bu_id'];
    plantId = json['plant_id'];
    departmentId = json['department_id'];
    locationId = json['location_id'];
    assetGroupId = json['asset_group_id'];
    assetId = json['asset_id'];
    breakdownCategoryId = json['breakdown_category_id'];
    breakdownSubCategoryId = json['breakdown_sub_category_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ticket_count'] = ticketCount;
    data['asset_count'] = assetCount;
    data['sum_of_downtime'] = sumOfDowntime;
    data['open'] = open;
    data['assign'] = assign;
    data['accept'] = accept;
    data['reject'] = reject;
    data['reassign'] = reassign;
    data['check_in'] = checkIn;
    data['on_hold'] = onHold;
    data['pending'] = pending;
    data['completed'] = completed;
    data['fixed'] = fixed;
    data['reopen'] = reopen;
    data['cancel'] = cancel;
    data['delete'] = delete;
    data['in_progress_tickets'] = inProgressTickets;
    data['mtbf'] = mtbf;
    data['mttr'] = mttr;
    data['company_code'] = companyCode;
    data['company_name'] = companyName;
    data['bu_code'] = buCode;
    data['bu_name'] = buName;
    data['plant_code'] = plantCode;
    data['plant_name'] = plantName;
    data['department_code'] = departmentCode;
    data['department_name'] = departmentName;
    data['location_code'] = locationCode;
    data['location_name'] = locationName;
    data['asset_group_code'] = assetGroupCode;
    data['asset_group_name'] = assetGroupName;
    data['asset_code'] = assetCode;
    data['asset_name'] = assetName;
    data['breakdown_category_code'] = breakdownCategoryCode;
    data['breakdown_category_name'] = breakdownCategoryName;
    data['breakdown_sub_category_code'] = breakdownSubCategoryCode;
    data['breakdown_sub_category_name'] = breakdownSubCategoryName;
    data['asset_model_name'] = assetModelName;
    data['company_id'] = companyId;
    data['bu_id'] = buId;
    data['plant_id'] = plantId;
    data['department_id'] = departmentId;
    data['location_id'] = locationId;
    data['asset_group_id'] = assetGroupId;
    data['asset_id'] = assetId;
    data['breakdown_category_id'] = breakdownCategoryId;
    data['breakdown_sub_category_id'] = breakdownSubCategoryId;
    return data;
  }
}
