class TicketDetail {
  bool? isError;
  String? message;
  List<TicketDetails>? ticketDetails;

  TicketDetail({this.isError, this.message, this.ticketDetails});

  TicketDetail.fromJson(Map<String, dynamic> json) {
    isError = json['is_error'];
    message = json['message'];
    if (json['ticket_details'] != null) {
      ticketDetails = <TicketDetails>[];
      json['ticket_details'].forEach((v) {
        ticketDetails!.add(TicketDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['is_error'] = isError;
    data['message'] = message;
    if (ticketDetails != null) {
      data['ticket_details'] =
          ticketDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  TicketDetail.fromError({required bool isErrorThrown,required String errorMessage}){
    isError = isErrorThrown;
    message = errorMessage;
  }
}

class TicketDetails {
  int? id;
  String? millDate;
  String? millShift;
  int? plantId;
  int? departmentId;
  int? assetGroupId;
  int? assetId;
  int? operator1Id;
  int? operator2Id;
  int? operator3Id;
  int? breakdownCategoryId;
  int? priorityId;
  String? description;
  int? statusId;
  int? assetStatus;
  String? ticketNo;
  String? reasonHold;
  String? otp;
  String? currentStopBeginTime;
  String? ackBeginTime;
  String? checkInTime;
  String? checkOutTime;
  String? lastCheckOutTime;
  String? completeBeginTime;
  String? fixedBeginTime;
  String? createdOn;
  int? createdBy;
  String? modifiedOn;
  int? beginSmsStatus;
  int? ackSmsStatus;
  int? ackSmsStatusPlant;
  int? completeSmsStatus;
  int? completeSmsStatusPlant;
  int? matlReqSmsStatus;
  String? why1;
  String? issue;
  String? action1;
  String? why2;
  String? rootCause;
  String? action2;
  String? why3;
  String? solution;
  String? action3;
  String? why4;
  String? due4;
  String? action4;
  String? why5;
  String? due5;
  String? action5;
  String? remarks;
  String? openComment;
  String? cancelComment;
  String? assignedComment;
  String? acceptComment;
  String? checkInComment;
  String? checkOutComment;
  String? rejectComment;
  String? holdComment;
  String? pendingComment;
  String? completedComment;
  String? reopenComment;
  int? fixedBy;
  int? downtime;
  int? actualDowntime;
  String? deleteComment;
  String? status;
  String? deletedOn;
  int? deletedBy;
  String? isNotification;
  String? rejectedBy;
  String? isMail;
  String? reassignComment;
  String? firstCheckInTime;
  String? assignBeginTime;
  int? locationId;
  String? breakdownImage;
  String? breakdownDoc;
  int? companyId;
  int? buId;
  int? breakdownSubCategoryId;
  int? engineerId;
  String? machineStatus;
  String? company;
  String? bu;
  String? plant;
  String? department;
  String? assignedToEngineer;
  String? priority;
  String? asset;
  String? assetSerialNo;
  String? assetNo;
  String? assetManufacturer;
  String? assetGroupName;
  String? stopBeginTime;
  String? acknowledgedBeginTime;
  String? assignedBy;
  String? acknowledgedBy;
  String? employeeMobile;
  String? employeeEmail;
  String? breakdownCategory;
  String? location;
  String? completeDuration;
  String? downtimeDuration;

  TicketDetails(
      {this.id,
      this.millDate,
      this.millShift,
      this.plantId,
      this.departmentId,
      this.assetGroupId,
      this.assetId,
      this.operator1Id,
      this.operator2Id,
      this.operator3Id,
      this.breakdownCategoryId,
      this.priorityId,
      this.description,
      this.statusId,
      this.assetStatus,
      this.ticketNo,
      this.reasonHold,
      this.otp,
      this.currentStopBeginTime,
      this.ackBeginTime,
      this.checkInTime,
      this.checkOutTime,
      this.lastCheckOutTime,
      this.completeBeginTime,
      this.fixedBeginTime,
      this.createdOn,
      this.createdBy,
      this.modifiedOn,
      this.beginSmsStatus,
      this.ackSmsStatus,
      this.ackSmsStatusPlant,
      this.completeSmsStatus,
      this.completeSmsStatusPlant,
      this.matlReqSmsStatus,
      this.why1,
      this.issue,
      this.action1,
      this.why2,
      this.rootCause,
      this.action2,
      this.why3,
      this.solution,
      this.action3,
      this.why4,
      this.due4,
      this.action4,
      this.why5,
      this.due5,
      this.action5,
      this.remarks,
      this.openComment,
      this.cancelComment,
      this.assignedComment,
      this.acceptComment,
      this.checkInComment,
      this.checkOutComment,
      this.rejectComment,
      this.holdComment,
      this.pendingComment,
      this.completedComment,
      this.reopenComment,
      this.fixedBy,
      this.downtime,
      this.actualDowntime,
      this.deleteComment,
      this.status,
      this.deletedOn,
      this.deletedBy,
      this.isNotification,
      this.rejectedBy,
      this.isMail,
      this.reassignComment,
      this.firstCheckInTime,
      this.assignBeginTime,
      this.locationId,
      this.breakdownImage,
      this.breakdownDoc,
      this.companyId,
      this.buId,
      this.breakdownSubCategoryId,
      this.engineerId,
      this.machineStatus,
      this.company,
      this.bu,
      this.plant,
      this.department,
      this.assignedToEngineer,
      this.priority,
      this.asset,
      this.assetSerialNo,
      this.assetNo,
      this.assetManufacturer,
      this.assetGroupName,
      this.stopBeginTime,
      this.acknowledgedBeginTime,
      this.assignedBy,
      this.acknowledgedBy,
      this.employeeMobile,
      this.employeeEmail,
      this.breakdownCategory,
      this.location,
      this.completeDuration,
      this.downtimeDuration});

  TicketDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    millDate = json['mill_date'];
    millShift = json['mill_shift'];
    plantId = json['plant_id'];
    departmentId = json['department_id'];
    assetGroupId = json['asset_group_id'];
    assetId = json['asset_id'];
    operator1Id = json['operator1_id'];
    operator2Id = json['operator2_id'];
    operator3Id = json['operator3_id'];
    breakdownCategoryId = json['breakdown_category_id'];
    priorityId = json['priority_id'];
    description = json['description'];
    statusId = json['status_id'];
    assetStatus = json['asset_status'];
    ticketNo = json['ticket_no'];
    reasonHold = json['reason_hold'];
    otp = json['otp'];
    currentStopBeginTime = json['current_stop_begin_time'];
    ackBeginTime = json['ack_begin_time'];
    checkInTime = json['check_in_time'];
    checkOutTime = json['check_out_time'];
    lastCheckOutTime = json['last_check_out_time'];
    completeBeginTime = json['complete_begin_time'];
    fixedBeginTime = json['fixed_begin_time'];
    createdOn = json['created_on'];
    createdBy = json['created_by'];
    modifiedOn = json['modified_on'];
    beginSmsStatus = json['begin_sms_status'];
    ackSmsStatus = json['ack_sms_status'];
    ackSmsStatusPlant = json['ack_sms_status_plant'];
    completeSmsStatus = json['complete_sms_status'];
    completeSmsStatusPlant = json['complete_sms_status_plant'];
    matlReqSmsStatus = json['matl_req_sms_status'];
    why1 = json['why1'];
    issue = json['issue'];
    action1 = json['action1'];
    why2 = json['why2'];
    rootCause = json['root_cause'];
    action2 = json['action2'];
    why3 = json['why3'];
    solution = json['solution'];
    action3 = json['action3'];
    why4 = json['why4'];
    due4 = json['due4'];
    action4 = json['action4'];
    why5 = json['why5'];
    due5 = json['due5'];
    action5 = json['action5'];
    remarks = json['remarks'];
    openComment = json['open_comment'];
    cancelComment = json['cancel_comment'];
    assignedComment = json['assigned_comment'];
    acceptComment = json['accept_comment'];
    checkInComment = json['check_in_comment'];
    checkOutComment = json['check_out_comment'];
    rejectComment = json['reject_comment'];
    holdComment = json['hold_comment'];
    pendingComment = json['pending_comment'];
    completedComment = json['completed_comment'];
    reopenComment = json['reopen_comment'];
    fixedBy = json['fixed_by'];
    downtime = json['downtime'];
    actualDowntime = json['actual_downtime'];
    deleteComment = json['delete_comment'];
    status = json['status'];
    deletedOn = json['deleted_on'];
    deletedBy = json['deleted_by'];
    isNotification = json['is_notification'];
    rejectedBy = json['rejected_by'];
    isMail = json['is_mail'];
    reassignComment = json['reassign_comment'];
    firstCheckInTime = json['first_check_in_time'];
    assignBeginTime = json['assign_begin_time'];
    locationId = json['location_id'];
    breakdownImage = json['breakdown_image'];
    breakdownDoc = json['breakdown_doc'];
    companyId = json['company_id'];
    buId = json['bu_id'];
    breakdownSubCategoryId = json['breakdown_sub_category_id'];
    engineerId = json['engineer_id'];
    machineStatus = json['machine_status'];
    company = json['company'];
    bu = json['bu'];
    plant = json['plant'];
    department = json['department'];
    assignedToEngineer = json['assigned_to_engineer'];
    priority = json['priority'];
    asset = json['asset'];
    assetSerialNo = json['asset_serial_no'];
    assetNo = json['asset_no'];
    assetManufacturer = json['asset_manufacturer'];
    assetGroupName = json['asset_group_name'];
    stopBeginTime = json['stop_begin_time'];
    acknowledgedBeginTime = json['acknowledged_begin_time'];
    assignedBy = json['assigned_by'];
    acknowledgedBy = json['acknowledged_by'];
    employeeMobile = json['employee_mobile'];
    employeeEmail = json['employee_email'];
    breakdownCategory = json['breakdown_category'];
    location = json['location'];
    completeDuration = json['complete_duration'];
    downtimeDuration = json['downtime_duration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['mill_date'] = millDate;
    data['mill_shift'] = millShift;
    data['plant_id'] = plantId;
    data['department_id'] = departmentId;
    data['asset_group_id'] = assetGroupId;
    data['asset_id'] = assetId;
    data['operator1_id'] = operator1Id;
    data['operator2_id'] = operator2Id;
    data['operator3_id'] = operator3Id;
    data['breakdown_category_id'] = breakdownCategoryId;
    data['priority_id'] = priorityId;
    data['description'] = description;
    data['status_id'] = statusId;
    data['asset_status'] = assetStatus;
    data['ticket_no'] = ticketNo;
    data['reason_hold'] = reasonHold;
    data['otp'] = otp;
    data['current_stop_begin_time'] = currentStopBeginTime;
    data['ack_begin_time'] = ackBeginTime;
    data['check_in_time'] = checkInTime;
    data['check_out_time'] = checkOutTime;
    data['last_check_out_time'] = lastCheckOutTime;
    data['complete_begin_time'] = completeBeginTime;
    data['fixed_begin_time'] = fixedBeginTime;
    data['created_on'] = createdOn;
    data['created_by'] = createdBy;
    data['modified_on'] = modifiedOn;
    data['begin_sms_status'] = beginSmsStatus;
    data['ack_sms_status'] = ackSmsStatus;
    data['ack_sms_status_plant'] = ackSmsStatusPlant;
    data['complete_sms_status'] = completeSmsStatus;
    data['complete_sms_status_plant'] = completeSmsStatusPlant;
    data['matl_req_sms_status'] = matlReqSmsStatus;
    data['why1'] = why1;
    data['issue'] = issue;
    data['action1'] = action1;
    data['why2'] = why2;
    data['root_cause'] = rootCause;
    data['action2'] = action2;
    data['why3'] = why3;
    data['solution'] = solution;
    data['action3'] = action3;
    data['why4'] = why4;
    data['due4'] = due4;
    data['action4'] = action4;
    data['why5'] = why5;
    data['due5'] = due5;
    data['action5'] = action5;
    data['remarks'] = remarks;
    data['open_comment'] = openComment;
    data['cancel_comment'] = cancelComment;
    data['assigned_comment'] = assignedComment;
    data['accept_comment'] = acceptComment;
    data['check_in_comment'] = checkInComment;
    data['check_out_comment'] = checkOutComment;
    data['reject_comment'] = rejectComment;
    data['hold_comment'] = holdComment;
    data['pending_comment'] = pendingComment;
    data['completed_comment'] = completedComment;
    data['reopen_comment'] = reopenComment;
    data['fixed_by'] = fixedBy;
    data['downtime'] = downtime;
    data['actual_downtime'] = actualDowntime;
    data['delete_comment'] = deleteComment;
    data['status'] = status;
    data['deleted_on'] = deletedOn;
    data['deleted_by'] = deletedBy;
    data['is_notification'] = isNotification;
    data['rejected_by'] = rejectedBy;
    data['is_mail'] = isMail;
    data['reassign_comment'] = reassignComment;
    data['first_check_in_time'] = firstCheckInTime;
    data['assign_begin_time'] = assignBeginTime;
    data['location_id'] = locationId;
    data['breakdown_image'] = breakdownImage;
    data['breakdown_doc'] = breakdownDoc;
    data['company_id'] = companyId;
    data['bu_id'] = buId;
    data['breakdown_sub_category_id'] = breakdownSubCategoryId;
    data['engineer_id'] = engineerId;
    data['machine_status'] = machineStatus;
    data['company'] = company;
    data['bu'] = bu;
    data['plant'] = plant;
    data['department'] = department;
    data['assigned_to_engineer'] = assignedToEngineer;
    data['priority'] = priority;
    data['asset'] = asset;
    data['asset_serial_no'] = assetSerialNo;
    data['asset_no'] = assetNo;
    data['asset_manufacturer'] = assetManufacturer;
    data['asset_group_name'] = assetGroupName;
    data['stop_begin_time'] = stopBeginTime;
    data['acknowledged_begin_time'] = acknowledgedBeginTime;
    data['assigned_by'] = assignedBy;
    data['acknowledged_by'] = acknowledgedBy;
    data['employee_mobile'] = employeeMobile;
    data['employee_email'] = employeeEmail;
    data['breakdown_category'] = breakdownCategory;
    data['location'] = location;
    data['complete_duration'] = completeDuration;
    data['downtime_duration'] = downtimeDuration;
    return data;
  }
}
