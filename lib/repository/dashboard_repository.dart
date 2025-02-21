// ignore_for_file: unused_local_variable

import 'package:auscurator/api_service_myconcept/api_service_new.dart';
import 'package:auscurator/api_service_myconcept/response.dart';
import 'package:auscurator/api_service_myconcept/response_extension.dart';
import 'package:auscurator/model/BreakdownTicketCountsModel.dart';
import 'package:auscurator/model/CategoryBasedModel.dart';
import 'package:auscurator/model/DepartmentListsModel.dart';
import 'package:auscurator/model/OpenCompletedModel.dart';
import 'package:auscurator/provider/all_provider.dart';
import 'package:auscurator/util/shared_util.dart';
import 'package:flutter/material.dart';

class DashboardRepository {
  Future<bool> dashboardTicketCounts(BuildContext context,
      {required String from_date,
      required String to_date,
      required String status}) async {
    final cId = SharedUtil().getcompanyId;
    final bId = SharedUtil().getBuId;
    final pId = SharedUtil().getPlantId;
    final dId = SharedUtil().getDepartmentId;
    final LId = SharedUtil().getLocationId;
    final LoginId = SharedUtil().getLoginId;

    final body = {
      "department_id": '',
      "company_id": "",
      'bu_id': '',
      'plant_id': pId == '0' ? '' : pId,
      'location_id': '',
      'asset_group_id': '',
      'asset_id': '',
      'breakdown_category_id': '',
      'breakdown_subcategory_id': '',
      'ticket_id': '',
      'engineer_id': '',
      'breakdown_status': '',
      'group_by': 'department',
      'report_type': 'cumulative',
      'period': status,
      'from_date': from_date,
      'to_date': to_date,
      'report_for': '',
      'exception_for': '',
      'operation': '',
      'operation_value': '',
      'limit_report_for': '',
      'limit_exception_for': '',
      'limit_order_by': '',
      'limit_operation_value': '',
      'report_data': '',
      'field_data': '',
      'user_type': '',
      'user_login_id': LoginId,
    };

    dashboardProvider.isLoading = true;
    ResponseData response =
        await APIService().post(context, "breakdown_reportLists/", body: body);
    dashboardProvider.isLoading = false;
    if (response.hasError(context)) return false;
    final jsonObj = response.data;
    dashboardProvider.breakdownTicketCountData =
        BreakdownTicketCountsModel.fromJson(jsonObj);
    String message = response.data['message'] ?? '';
    // if (message.isNotEmpty)
    //   showMessage(context: context, isError: true, responseMessage: message);
    return true;
  }

  Future<bool> openCompleted(BuildContext context,
      {required String from_date,
      required String to_date,
      required String status}) async {
    final pId = SharedUtil().getPlantId;
    final dId = SharedUtil().getDepartmentId;
    final loginId = SharedUtil().getLoginId;
    final body = {
      'department_id': dId == '0' ? '' : dId,
      'company_id': '',
      'bu_id': '',
      'plant_id': pId == '0' ? '' : pId,
      'location_id': '',
      'asset_group_id': '',
      'asset_id': '',
      'breakdown_category_id': '',
      'breakdown_subcategory_id': '',
      'ticket_id': '',
      'engineer_id': '',
      'breakdown_status': '',
      'group_by': 'department',
      'report_type': 'summary',
      'period': status,
      'from_date': from_date,
      'to_date': to_date,
      'report_for': '',
      'exception_for': '',
      'operation': '',
      'operation_value': '',
      'limit_report_for': '',
      'limit_exception_for': '',
      'limit_order_by': '',
      'limit_operation_value': '',
      'report_data': '',
      'field_data': '',
      'user_type': '',
      'user_login_id': loginId,
    };

    dashboardProvider.isLoading = true;
    ResponseData response =
        await APIService().post(context, "breakdown_reportLists/", body: body);
    dashboardProvider.isLoading = false;
    if (response.hasError(context)) return false;
    final jsonObj = response.data;
    dashboardProvider.openCompleteData = OpenCompletedModel.fromJson(jsonObj);
    String message = response.data['message'] ?? '';
    // if (message.isNotEmpty)
    //   showMessage(context: context, isError: true, responseMessage: message);
    return true;
  }

  Future<bool> categoryBased(BuildContext context,
      {required String from_date,
      required String to_date,
      required String status}) async {
    final pId = SharedUtil().getPlantId;
    final dId = SharedUtil().getDepartmentId;
    final loginId = SharedUtil().getLoginId;
    final body = {
      'department_id': dId == '0' ? '' : dId,
      'company_id': '',
      'bu_id': '',
      'plant_id': pId == '0' ? '' : pId,
      'location_id': '',
      'asset_group_id': '',
      'asset_id': '',
      'breakdown_category_id': '',
      'breakdown_subcategory_id': '',
      'ticket_id': '',
      'engineer_id': '',
      'breakdown_status': '',
      'group_by': 'department',
      'report_type': 'summary',
      'period': status,
      'from_date': from_date,
      'to_date': to_date,
      'report_for': '',
      'exception_for': '',
      'operation': '',
      'operation_value': '',
      'limit_report_for': '',
      'limit_exception_for': '',
      'limit_order_by': '',
      'limit_operation_value': '',
      'report_data': '',
      'field_data': '',
      'user_type': '',
      'user_login_id': loginId,
    };

    dashboardProvider.isLoading = true;
    ResponseData response =
        await APIService().post(context, "breakdown_reportLists/", body: body);
    dashboardProvider.isLoading = false;
    if (response.hasError(context)) return false;
    final jsonObj = response.data;
    dashboardProvider.categoryBasedData = CategoryBasedModel.fromJson(jsonObj);
    String message = response.data['message'] ?? '';
    // if (message.isNotEmpty)
    //   showMessage(context: context, isError: true, responseMessage: message);
    return true;
  }

  Future<bool> departmentLists(BuildContext context) async {
    final cId = SharedUtil().getcompanyId;
    final bId = SharedUtil().getBuId;
    final pId = SharedUtil().getPlantId;
    final dId = SharedUtil().getDepartmentId;
    final body = {
      'department_id': dId == '0' ? '' : dId,
      'company_id': cId == '0' ? '' : cId,
      'bu_id': bId == '0' ? '' : bId,
      'plant_id': pId == '0' ? '' : pId,
      'status': 'active',
    };

    dashboardProvider.isLoading = true;
    ResponseData response =
        await APIService().post(context, "departmentLists/", body: body);
    dashboardProvider.isLoading = false;
    if (response.hasError(context)) return false;
    final jsonObj = response.data;
    dashboardProvider.departmentListData =
        DepartmentListsModel.fromJson(jsonObj);
    String message = response.data['message'] ?? '';
    // if (message.isNotEmpty)
    //   showMessage(context: context, isError: true, responseMessage: message);
    return true;
  }
}
