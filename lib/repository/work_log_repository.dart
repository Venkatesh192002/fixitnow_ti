import 'package:auscurator/api_service_myconcept/api_helper.dart';
import 'package:auscurator/api_service_myconcept/api_service_new.dart';
import 'package:auscurator/api_service_myconcept/response.dart';
import 'package:auscurator/api_service_myconcept/response_extension.dart';
import 'package:auscurator/machine_iot/screens/work_log_screen.dart';
import 'package:auscurator/model/work_log_model.dart';
import 'package:auscurator/model/worklogdetail_model.dart';
import 'package:auscurator/provider/all_provider.dart';
import 'package:auscurator/util/shared_util.dart';
import 'package:flutter/material.dart';

class WorkLogRepository {
  Future<bool> getWorkLogList(BuildContext context,
      {required String ticket_no}) async {
    final LoginId = SharedUtil().getLoginId;
    print('login_id->$LoginId');
    final body = {
      'ticket_id': ticket_no,
      'breakdown_status': '',
      'period': '',
      'from_date': '',
      'to_date': '',
      'user_login_id': LoginId
    };
    workLogProvider.isLoading = true;
    ResponseData response = await APIService()
        .post(context, "get_breakdown_detail_list/", body: body);
    workLogProvider.isLoading = false;

    if (response.hasError(context)) return false;
    final jsonObj = response.data;
    workLogProvider.workLogData = WorklogModel.fromJson(jsonObj);
    // getworlLogDetail(context, ticket_no: ticket_no);

    String message = response.data['message'] ?? '';

    if (message.isNotEmpty) showMessage1(message);
    return true;
  }

  Future<bool> getworlLogDetail(BuildContext context,
      {required String ticket_no,
      required String createdOn,
      required String ticketNumber}) async {
    final LoginId = SharedUtil().getLoginId;
    print('login_id->$LoginId');
    final body = {
      'ticket_id': ticket_no,
      'user_login_id': LoginId,
      'created_on': createdOn
    };
    workLogProvider.isLoading = true;
    ResponseData response = await APIService()
        .post(context, "get_breakdown_work_log_list/", body: body);
    workLogProvider.isLoading = false;

    if (response.hasError(context)) return false;
    final jsonObj = response.data;
    // logger.e(jsonObj);
    workLogProvider.workLogDetailData = WorklogDetailModel.fromJson(jsonObj);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WorkLogScreen(ticketNo: ticketNumber),
      ),
    );
    // String message = response.data['message'] ?? '';

    // if (message.isNotEmpty) showMessage1(message);
    return true;
  }
}
