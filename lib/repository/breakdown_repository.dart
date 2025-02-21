import 'package:auscurator/api_service_myconcept/api_service_new.dart';
import 'package:auscurator/api_service_myconcept/keys.dart';
import 'package:auscurator/api_service_myconcept/response.dart';
import 'package:auscurator/api_service_myconcept/response_extension.dart';
import 'package:auscurator/model/BreakdownTicketModel.dart';
import 'package:auscurator/model/MainCategoryModel.dart';
import 'package:auscurator/model/SubCategoryModel.dart';
import 'package:auscurator/model/TicketDetailModel.dart';
import 'package:auscurator/model/root_cause_model.dart';
import 'package:auscurator/provider/all_provider.dart';
import 'package:auscurator/util/shared_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BreakdownRepository {
  Future<bool> getBreakDownDetailList(BuildContext context,
      {required String ticket_no}) async {
    final LoginId = SharedUtil().getLoginId;

    final body = {
      'ticket_id': ticket_no,
      'breakdown_status': '',
      'period': '',
      'from_date': '',
      'to_date': '',
      'user_login_id': LoginId
    };
    breakProvider.isLoading = true;
    ResponseData response = await APIService()
        .post(context, "get_breakdown_detail_list/", body: body);
    breakProvider.isLoading = false;
    if (response.hasError(context)) return false;
    final jsonObj = response.data;
    logger.i(jsonObj);
    breakProvider.ticketDetailData = TicketDetailModel.fromJson(jsonObj);

    // String message = response.data['message'] ?? '';
    // if (message.isNotEmpty)
    //   showMessage(context: context, isError: true, responseMessage: message);
    return true;
  }

  Future<bool> getListOfIssue(
    BuildContext context,
  ) async {
    final body = {
      'breakdown_category_id': "",
      'company_id': '',
      'status': "active"
    };

    breakProvider.isLoading = true;
    ResponseData response = await APIService()
        .post(context, "breakdown_categoryLists/", body: body);
    breakProvider.isLoading = false;
    if (response.hasError(context)) return false;
    final jsonObj = response.data;
    breakProvider.mainCategoryData = MainCategoryModel.fromJson(jsonObj);
    // String message = response.data['message'] ?? '';
    // if (message.isNotEmpty)
    //   showMessage(context: context, isError: true, responseMessage: message);
    return true;
  }

  Future<bool> getListOfBreadownSub(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? breakdownCategoryId =
        prefs.getString('breakdown_category_id') ?? "";
    String? assetGroupid = prefs.getString('asset_group_id') ?? "";

    final body = {
      'breakdown_assignment_id': "",
      'company_id': '',
      'bu_id': '',
      "plant_id": '',
      "asset_group_id": assetGroupid,
      'breakdown_category_id': breakdownCategoryId,
      'breakdown_sub_category_id': "",
      'status': "active"
    };
    breakProvider.isLoading = true;
    ResponseData response = await APIService()
        .post(context, "breakdown_assignmentLists/", body: body);
    breakProvider.isLoading = false;
    if (response.hasError(context)) return false;
    final jsonObj = response.data;
    breakProvider.subCategoryData = SubCategoryModel.fromJson(jsonObj);
    // String message = response.data['message'] ?? '';
    // if (message.isNotEmpty)
    //   showMessage(context: context, isError: true, responseMessage: message);
    return true;
  }

  Future<bool> getListOfBreadownSub1(BuildContext context,
      {required String breakdownCategoryId,
      required String assetGroupid}) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // String? breakdownCategoryId =
    //     prefs.getString('breakdown_category_id') ?? "";
    // String? assetGroupid = prefs.getString('asset_group_id') ?? "";

    final body = {
      'breakdown_assignment_id': "",
      'company_id': '',
      'bu_id': '',
      "plant_id": '',
      "asset_group_id": assetGroupid,
      'breakdown_category_id': breakdownCategoryId,
      'breakdown_sub_category_id': "",
      'status': "active"
    };

    breakProvider.isLoading = true;
    ResponseData response = await APIService()
        .post(context, "breakdown_assignmentLists/", body: body);
    breakProvider.isLoading = false;
    if (response.hasError(context)) return false;
    final jsonObj = response.data;
    breakProvider.subCategoryData = SubCategoryModel.fromJson(jsonObj);
    // String message = response.data['message'] ?? '';
    // if (message.isNotEmpty)
    //   showMessage(context: context, isError: true, responseMessage: message);
    return true;
  }

  Future<bool> getBreakDownStatusList(BuildContext context,
      {required String breakdown_status,
      required String period,
      required String from_date,
      required String to_date,
      required String user_login_id}) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // String? breakdownCategoryId =
    //     prefs.getString('breakdown_category_id') ?? "";
    // String? assetGroupid = prefs.getString('asset_group_id') ?? "";

    final LoginId = SharedUtil().getLoginId;
    final body = {
      'ticket_id': '',
      'breakdown_status': breakdown_status,
      'period': period,
      'from_date': from_date,
      'to_date': to_date,
      'user_login_id': LoginId
    };
    // logger.i(body);
    breakProvider.isLoading = true;
    ResponseData response = await APIService()
        .post(context, "get_breakdown_detail_list/", body: body);
    breakProvider.isLoading = false;
    if (response.hasError(context)) return false;
    final jsonObj = response.data;
    // logger.i(jsonObj);

    breakProvider.breakDownOverallData =
        BreakkdownTicketModel.fromJson(jsonObj);
    // String message = response.data['message'] ?? '';
    // if (message.isNotEmpty)
    //   showMessage(context: context, isError: true, responseMessage: message);
    return true;
  }

  Future<bool> getRootCauseList(BuildContext context) async {
    final body = {
      'id': '',
      'ref_id': "",
    };
    // logger.i(body);
    breakProvider.isLoading = true;
    ResponseData response =
        await APIService().post(context, "root_causeLists/", body: body);
    breakProvider.isLoading = false;
    if (response.hasError(context)) return false;
    final jsonObj = response.data;
    // logger.i(jsonObj);

    breakProvider.rootCauseData = RootCauseModel.fromJson(jsonObj);
    // String message = response.data['message'] ?? '';
    // if (message.isNotEmpty)
    //   showMessage(context: context, isError: true, responseMessage: message);
    return true;
  }
}
