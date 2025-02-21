class TicketDetailReport {
  bool? isError;
  String? message;
  List<BreakdownReportLists>? breakdownReportLists;

  TicketDetailReport({this.isError, this.message, this.breakdownReportLists});

  TicketDetailReport.fromJson(Map<String, dynamic> json) {
    isError = json['is_error'];
    message = json['message'];
    if (json['breakdown_reportLists'] != null) {
      breakdownReportLists = <BreakdownReportLists>[];
      json['breakdown_reportLists'].forEach((v) {
        breakdownReportLists!.add(BreakdownReportLists.fromJson(v));
      });
    }
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

  TicketDetailReport.fromError(
      {required bool isErrorThrown, required String errorMessage}) {
    isError = isErrorThrown;
    message = errorMessage;
  }
}

class BreakdownReportLists {
  int? ticket;
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
  String? ticketNo;
  int? completedTickets;
  int? openTickets;
  int? assignedTickets;
  int? acceptedTickets;
  int? inProgressTickets;
  int? pendingTickets;
  int? cancelledTickets;
  String? assetStatus;
  String? operator;
  String? operatorName;
  String? attendBy;
  String? attendByName;
  String? raisedByName;
  String? fixedByName;
  String? rejectedByName;
  String? raisedBy;
  String? why1;
  String? why2;
  String? why3;
  String? why4;
  String? why5;
  String? issue;
  String? rootCause;
  String? solution;
  String? due4;
  String? due5;
  String? action1;
  String? action2;
  String? action3;
  String? action4;
  String? action5;
  int? lossId;
  int? downtime;
  String? remarks;
  String? serialNo;
  String? date;
  String? stopBeginTime;
  String? completeBeginTime;
  String? ackBeginTime;
  Null assignBeginTime;
  String? fixedBeginTime;
  String? cancelComment;
  String? reopenComment;

  BreakdownReportLists(
      {this.ticket,
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
      this.ticketNo,
      this.completedTickets,
      this.openTickets,
      this.assignedTickets,
      this.acceptedTickets,
      this.inProgressTickets,
      this.pendingTickets,
      this.cancelledTickets,
      this.assetStatus,
      this.operator,
      this.operatorName,
      this.attendBy,
      this.attendByName,
      this.raisedByName,
      this.fixedByName,
      this.rejectedByName,
      this.raisedBy,
      this.why1,
      this.why2,
      this.why3,
      this.why4,
      this.why5,
      this.issue,
      this.rootCause,
      this.solution,
      this.due4,
      this.due5,
      this.action1,
      this.action2,
      this.action3,
      this.action4,
      this.action5,
      this.lossId,
      this.downtime,
      this.remarks,
      this.serialNo,
      this.date,
      this.stopBeginTime,
      this.completeBeginTime,
      this.ackBeginTime,
      this.assignBeginTime,
      this.fixedBeginTime,
      this.cancelComment,
      this.reopenComment});

  BreakdownReportLists.fromJson(Map<String, dynamic> json) {
    ticket = json['ticket'];
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
    ticketNo = json['ticket_no'];
    completedTickets = json['completed_tickets'];
    openTickets = json['open_tickets'];
    assignedTickets = json['assigned_tickets'];
    acceptedTickets = json['accepted_tickets'];
    inProgressTickets = json['in_progress_tickets'];
    pendingTickets = json['pending_tickets'];
    cancelledTickets = json['cancelled_tickets'];
    assetStatus = json['asset_status'];
    operator = json['operator'];
    operatorName = json['operator_name'];
    attendBy = json['attend_by'];
    attendByName = json['attend_by_name'];
    raisedByName = json['raised_by_name'];
    fixedByName = json['fixed_by_name'];
    rejectedByName = json['rejected_by_name'];
    raisedBy = json['raised_by'];
    why1 = json['why1'];
    why2 = json['why2'];
    why3 = json['why3'];
    why4 = json['why4'];
    why5 = json['why5'];
    issue = json['issue'];
    rootCause = json['root_cause'];
    solution = json['solution'];
    due4 = json['due4'];
    due5 = json['due5'];
    action1 = json['action1'];
    action2 = json['action2'];
    action3 = json['action3'];
    action4 = json['action4'];
    action5 = json['action5'];
    lossId = json['loss_id'];
    downtime = json['downtime'];
    remarks = json['remarks'];
    serialNo = json['serial_no'];
    date = json['date'];
    stopBeginTime = json['stop_begin_time'];
    completeBeginTime = json['complete_begin_time'];
    ackBeginTime = json['ack_begin_time'];
    assignBeginTime = json['assign_begin_time'];
    fixedBeginTime = json['fixed_begin_time'];
    cancelComment = json['cancel_comment'];
    reopenComment = json['reopen_comment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ticket'] = ticket;
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
    data['ticket_no'] = ticketNo;
    data['completed_tickets'] = completedTickets;
    data['open_tickets'] = openTickets;
    data['assigned_tickets'] = assignedTickets;
    data['accepted_tickets'] = acceptedTickets;
    data['in_progress_tickets'] = inProgressTickets;
    data['pending_tickets'] = pendingTickets;
    data['cancelled_tickets'] = cancelledTickets;
    data['asset_status'] = assetStatus;
    data['operator'] = operator;
    data['operator_name'] = operatorName;
    data['attend_by'] = attendBy;
    data['attend_by_name'] = attendByName;
    data['raised_by_name'] = raisedByName;
    data['fixed_by_name'] = fixedByName;
    data['rejected_by_name'] = rejectedByName;
    data['raised_by'] = raisedBy;
    data['why1'] = why1;
    data['why2'] = why2;
    data['why3'] = why3;
    data['why4'] = why4;
    data['why5'] = why5;
    data['issue'] = issue;
    data['root_cause'] = rootCause;
    data['solution'] = solution;
    data['due4'] = due4;
    data['due5'] = due5;
    data['action1'] = action1;
    data['action2'] = action2;
    data['action3'] = action3;
    data['action4'] = action4;
    data['action5'] = action5;
    data['loss_id'] = lossId;
    data['downtime'] = downtime;
    data['remarks'] = remarks;
    data['serial_no'] = serialNo;
    data['date'] = date;
    data['stop_begin_time'] = stopBeginTime;
    data['complete_begin_time'] = completeBeginTime;
    data['ack_begin_time'] = ackBeginTime;
    data['assign_begin_time'] = assignBeginTime;
    data['fixed_begin_time'] = fixedBeginTime;
    data['cancel_comment'] = cancelComment;
    data['reopen_comment'] = reopenComment;
    return data;
  }
}
