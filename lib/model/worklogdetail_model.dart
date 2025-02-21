class WorklogDetailModel {
  bool? isError;
  String? message;
  List<BreakdownWorkLogList>? breakdownWorkLogList;

  WorklogDetailModel({this.isError, this.message, this.breakdownWorkLogList});

  WorklogDetailModel.fromJson(Map<String, dynamic> json) {
    isError = json['is_error'];
    message = json['message'];
    if (json['breakdown_work_log_list'] != null) {
      breakdownWorkLogList = <BreakdownWorkLogList>[];
      json['breakdown_work_log_list'].forEach((v) {
        breakdownWorkLogList!.add(new BreakdownWorkLogList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['is_error'] = this.isError;
    data['message'] = this.message;
    if (this.breakdownWorkLogList != null) {
      data['breakdown_work_log_list'] =
          this.breakdownWorkLogList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BreakdownWorkLogList {
  int? id;
  int? refId;
  int? userId;
  String? type;
  int? assignedTo;
  String? comment;
  String? dateTime;
  int? statusId;
  String? loginUserName;
  String? assignedToEngineerName;

  BreakdownWorkLogList(
      {this.id,
      this.refId,
      this.userId,
      this.type,
      this.assignedTo,
      this.comment,
      this.dateTime,
      this.statusId,
      this.loginUserName,
      this.assignedToEngineerName});

  BreakdownWorkLogList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    refId = json['ref_id'];
    userId = json['user_id'];
    type = json['type'];
    assignedTo = json['assigned_to'];
    comment = json['comment'];
    dateTime = json['date_time'];
    statusId = json['status_id'];
    loginUserName = json['login_user_name'];
    assignedToEngineerName = json['assigned_to_engineer_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['ref_id'] = this.refId;
    data['user_id'] = this.userId;
    data['type'] = this.type;
    data['assigned_to'] = this.assignedTo;
    data['comment'] = this.comment;
    data['date_time'] = this.dateTime;
    data['status_id'] = this.statusId;
    data['login_user_name'] = this.loginUserName;
    data['assigned_to_engineer_name'] = this.assignedToEngineerName;
    return data;
  }
}