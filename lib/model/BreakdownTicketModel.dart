class BreakkdownTicketModel {
  bool? isError;
  String? message;
  List<BreakdownDetailList>? breakdownDetailList;
  List<BreakdownListCount>? breakdownListCount;

  BreakkdownTicketModel(
      {this.isError,
      this.message,
      this.breakdownDetailList,
      this.breakdownListCount});

  BreakkdownTicketModel.fromJson(Map<String, dynamic> json) {
    isError = json['is_error'];
    message = json['message'];
    if (json['breakdown_detail_list'] != null) {
      breakdownDetailList = <BreakdownDetailList>[];
      json['breakdown_detail_list'].forEach((v) {
        breakdownDetailList!.add(new BreakdownDetailList.fromJson(v));
      });
    }
    if (json['breakdown_list_count'] != null) {
      breakdownListCount = <BreakdownListCount>[];
      json['breakdown_list_count'].forEach((v) {
        breakdownListCount!.add(new BreakdownListCount.fromJson(v));
      });
    }
  }
  BreakkdownTicketModel.fromError(
      {required bool isErrorThrown, required String errorMessage}) {
    isError = isErrorThrown;
    message = errorMessage;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['is_error'] = this.isError;
    data['message'] = this.message;
    if (this.breakdownDetailList != null) {
      data['breakdown_detail_list'] =
          this.breakdownDetailList!.map((v) => v.toJson()).toList();
    }
    if (this.breakdownListCount != null) {
      data['breakdown_list_count'] =
          this.breakdownListCount!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BreakdownDetailList {
  int? id;
  String? millDate;
  String? millShift;
  int? plantId;
  int? departmentId;
  int? assetGroupId;
  int? assetId;
  String? operator1Id;
  String? operator2Id;
  String? operator3Id;
  int? breakdownCategoryId;
  String? priority;
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
  String? createdBy;
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
  String? fixedBy;
  int? downtime;
  int? actualDowntime;
  String? deleteComment;
  String? status;
  String? deletedOn;
  String? deletedBy;
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
  int? reassignEngineerId1;
  int? reassignEngineerId2;
  int? reassignEngineerId3;
  String? reassignComment1;
  String? reassignComment2;
  String? reassignComment3;
  int? reassignBy1;
  int? reassignBy2;
  int? reassignBy3;
  String? reassignTime1;
  String? reassignTime2;
  String? reassignTime3;
  int? reopenBy;
  int? assignBy;
  String? ticketFrom;
  int? assetPartsId;
  int? engineerCompletion;
  String? reopenTime;
  String? approvalComment;
  String? approvalState;
  int? headResponseTime;
  int? headResponseCount;
  int? engineerResponseTime;
  int? engineerResponseCount;
  String? lastHeadResponseTime;
  String? company;
  String? bu;
  String? plant;
  String? department;
  String? locationName;
  String? breakdownSubCategoryName;
  String? asset;
  String? assetGroupName;
  String? breakdownCategoryName;
  String? assetSerialNo;
  String? stopBeginTime;
  String? assignedToEngineer;
  int? createdById;
  String? partName;
  String? partMake;
  String? partSno;
  int? downtimeDuration;
  String? rootCauseId;

  BreakdownDetailList(
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
      this.priority,
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
      this.reassignEngineerId1,
      this.reassignEngineerId2,
      this.reassignEngineerId3,
      this.reassignComment1,
      this.reassignComment2,
      this.reassignComment3,
      this.reassignBy1,
      this.reassignBy2,
      this.reassignBy3,
      this.reassignTime1,
      this.reassignTime2,
      this.reassignTime3,
      this.reopenBy,
      this.assignBy,
      this.ticketFrom,
      this.assetPartsId,
      this.engineerCompletion,
      this.reopenTime,
      this.approvalComment,
      this.approvalState,
      this.headResponseTime,
      this.headResponseCount,
      this.engineerResponseTime,
      this.engineerResponseCount,
      this.lastHeadResponseTime,
      this.company,
      this.bu,
      this.plant,
      this.department,
      this.locationName,
      this.breakdownSubCategoryName,
      this.asset,
      this.assetGroupName,
      this.breakdownCategoryName,
      this.assetSerialNo,
      this.stopBeginTime,
      this.assignedToEngineer,
      this.createdById,
      this.partName,
      this.partMake,
      this.partSno,
      this.downtimeDuration,
      this.rootCauseId});

  BreakdownDetailList.fromJson(Map<String, dynamic> json) {
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
    priority = json['priority'];
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
    reassignEngineerId1 = json['reassign_engineer_id_1'];
    reassignEngineerId2 = json['reassign_engineer_id_2'];
    reassignEngineerId3 = json['reassign_engineer_id_3'];
    reassignComment1 = json['reassign_comment_1'];
    reassignComment2 = json['reassign_comment_2'];
    reassignComment3 = json['reassign_comment_3'];
    reassignBy1 = json['reassign_by_1'];
    reassignBy2 = json['reassign_by_2'];
    reassignBy3 = json['reassign_by_3'];
    reassignTime1 = json['reassign_time_1'];
    reassignTime2 = json['reassign_time_2'];
    reassignTime3 = json['reassign_time_3'];
    reopenBy = json['reopen_by'];
    assignBy = json['assign_by'];
    ticketFrom = json['ticket_from'];
    assetPartsId = json['asset_parts_id'];
    engineerCompletion = json['engineer_completion'];
    reopenTime = json['reopen_time'];
    approvalComment = json['approval_comment'];
    approvalState = json['approval_state'];
    headResponseTime = json['head_response_time'];
    headResponseCount = json['head_response_count'];
    engineerResponseTime = json['engineer_response_time'];
    engineerResponseCount = json['engineer_response_count'];
    lastHeadResponseTime = json['last_head_response_time'];
    company = json['company'];
    bu = json['bu'];
    plant = json['plant'];
    department = json['department'];
    locationName = json['location_name'];
    breakdownSubCategoryName = json['breakdown_sub_category_name'];
    asset = json['asset'];
    assetGroupName = json['asset_group_name'];
    breakdownCategoryName = json['breakdown_category_name'];
    assetSerialNo = json['asset_serial_no'];
    stopBeginTime = json['stop_begin_time'];
    assignedToEngineer = json['assigned_to_engineer'];
    createdById = json['created_by_id'];
    partName = json['part_name'];
    partMake = json['part_make'];
    partSno = json['part_sno'];
    downtimeDuration = json['downtime_duration'];
    rootCauseId = json['root_cause_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['mill_date'] = this.millDate;
    data['mill_shift'] = this.millShift;
    data['plant_id'] = this.plantId;
    data['department_id'] = this.departmentId;
    data['asset_group_id'] = this.assetGroupId;
    data['asset_id'] = this.assetId;
    data['operator1_id'] = this.operator1Id;
    data['operator2_id'] = this.operator2Id;
    data['operator3_id'] = this.operator3Id;
    data['breakdown_category_id'] = this.breakdownCategoryId;
    data['priority'] = this.priority;
    data['description'] = this.description;
    data['status_id'] = this.statusId;
    data['asset_status'] = this.assetStatus;
    data['ticket_no'] = this.ticketNo;
    data['reason_hold'] = this.reasonHold;
    data['otp'] = this.otp;
    data['current_stop_begin_time'] = this.currentStopBeginTime;
    data['ack_begin_time'] = this.ackBeginTime;
    data['check_in_time'] = this.checkInTime;
    data['check_out_time'] = this.checkOutTime;
    data['last_check_out_time'] = this.lastCheckOutTime;
    data['complete_begin_time'] = this.completeBeginTime;
    data['fixed_begin_time'] = this.fixedBeginTime;
    data['created_on'] = this.createdOn;
    data['created_by'] = this.createdBy;
    data['modified_on'] = this.modifiedOn;
    data['begin_sms_status'] = this.beginSmsStatus;
    data['ack_sms_status'] = this.ackSmsStatus;
    data['ack_sms_status_plant'] = this.ackSmsStatusPlant;
    data['complete_sms_status'] = this.completeSmsStatus;
    data['complete_sms_status_plant'] = this.completeSmsStatusPlant;
    data['matl_req_sms_status'] = this.matlReqSmsStatus;
    data['why1'] = this.why1;
    data['issue'] = this.issue;
    data['action1'] = this.action1;
    data['why2'] = this.why2;
    data['root_cause'] = this.rootCause;
    data['action2'] = this.action2;
    data['why3'] = this.why3;
    data['solution'] = this.solution;
    data['action3'] = this.action3;
    data['why4'] = this.why4;
    data['due4'] = this.due4;
    data['action4'] = this.action4;
    data['why5'] = this.why5;
    data['due5'] = this.due5;
    data['action5'] = this.action5;
    data['remarks'] = this.remarks;
    data['open_comment'] = this.openComment;
    data['cancel_comment'] = this.cancelComment;
    data['assigned_comment'] = this.assignedComment;
    data['accept_comment'] = this.acceptComment;
    data['check_in_comment'] = this.checkInComment;
    data['check_out_comment'] = this.checkOutComment;
    data['reject_comment'] = this.rejectComment;
    data['hold_comment'] = this.holdComment;
    data['pending_comment'] = this.pendingComment;
    data['completed_comment'] = this.completedComment;
    data['reopen_comment'] = this.reopenComment;
    data['fixed_by'] = this.fixedBy;
    data['downtime'] = this.downtime;
    data['actual_downtime'] = this.actualDowntime;
    data['delete_comment'] = this.deleteComment;
    data['status'] = this.status;
    data['deleted_on'] = this.deletedOn;
    data['deleted_by'] = this.deletedBy;
    data['is_notification'] = this.isNotification;
    data['rejected_by'] = this.rejectedBy;
    data['is_mail'] = this.isMail;
    data['reassign_comment'] = this.reassignComment;
    data['first_check_in_time'] = this.firstCheckInTime;
    data['assign_begin_time'] = this.assignBeginTime;
    data['location_id'] = this.locationId;
    data['breakdown_image'] = this.breakdownImage;
    data['breakdown_doc'] = this.breakdownDoc;
    data['company_id'] = this.companyId;
    data['bu_id'] = this.buId;
    data['breakdown_sub_category_id'] = this.breakdownSubCategoryId;
    data['engineer_id'] = this.engineerId;
    data['reassign_engineer_id_1'] = this.reassignEngineerId1;
    data['reassign_engineer_id_2'] = this.reassignEngineerId2;
    data['reassign_engineer_id_3'] = this.reassignEngineerId3;
    data['reassign_comment_1'] = this.reassignComment1;
    data['reassign_comment_2'] = this.reassignComment2;
    data['reassign_comment_3'] = this.reassignComment3;
    data['reassign_by_1'] = this.reassignBy1;
    data['reassign_by_2'] = this.reassignBy2;
    data['reassign_by_3'] = this.reassignBy3;
    data['reassign_time_1'] = this.reassignTime1;
    data['reassign_time_2'] = this.reassignTime2;
    data['reassign_time_3'] = this.reassignTime3;
    data['reopen_by'] = this.reopenBy;
    data['assign_by'] = this.assignBy;
    data['ticket_from'] = this.ticketFrom;
    data['asset_parts_id'] = this.assetPartsId;
    data['engineer_completion'] = this.engineerCompletion;
    data['reopen_time'] = this.reopenTime;
    data['approval_comment'] = this.approvalComment;
    data['approval_state'] = this.approvalState;
    data['head_response_time'] = this.headResponseTime;
    data['head_response_count'] = this.headResponseCount;
    data['engineer_response_time'] = this.engineerResponseTime;
    data['engineer_response_count'] = this.engineerResponseCount;
    data['last_head_response_time'] = this.lastHeadResponseTime;
    data['company'] = this.company;
    data['bu'] = this.bu;
    data['plant'] = this.plant;
    data['department'] = this.department;
    data['location_name'] = this.locationName;
    data['breakdown_sub_category_name'] = this.breakdownSubCategoryName;
    data['asset'] = this.asset;
    data['asset_group_name'] = this.assetGroupName;
    data['breakdown_category_name'] = this.breakdownCategoryName;
    data['asset_serial_no'] = this.assetSerialNo;
    data['stop_begin_time'] = this.stopBeginTime;
    data['assigned_to_engineer'] = this.assignedToEngineer;
    data['created_by_id'] = this.createdById;
    data['part_name'] = this.partName;
    data['part_make'] = this.partMake;
    data['part_sno'] = this.partSno;
    data['downtime_duration'] = this.downtimeDuration;
    data['root_cause_id'] = this.rootCauseId;
    return data;
  }
}

class BreakdownListCount {
  int? assigned;
  int? open;
  int? onProgress;
  int? accepted;
  int? acknowledge;
  int? rca;
  int? approvalMfg;
  int? holdPending;
  int? closed;

  BreakdownListCount(
      {this.assigned,
      this.open,
      this.onProgress,
      this.accepted,
      this.acknowledge,
      this.rca,
      this.approvalMfg,
      this.holdPending,
      this.closed});

  BreakdownListCount.fromJson(Map<String, dynamic> json) {
    assigned = json['assigned'];
    open = json['open'];
    onProgress = json['on_progress'];
    accepted = json['accepted'];
    acknowledge = json['acknowledge'];
    rca = json['rca'];
    approvalMfg = json['approval_mfg'];
    holdPending = json['hold_pending'];
    closed = json['closed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['assigned'] = this.assigned;
    data['open'] = this.open;
    data['on_progress'] = this.onProgress;
    data['accepted'] = this.accepted;
    data['acknowledge'] = this.acknowledge;
    data['rca'] = this.rca;
    data['approval_mfg'] = this.approvalMfg;
    data['hold_pending'] = this.holdPending;
    data['closed'] = this.closed;
    return data;
  }
}
