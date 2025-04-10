import 'package:auscurator/api_service_myconcept/api_service_new.dart';
import 'package:auscurator/api_service_myconcept/keys.dart';
import 'package:auscurator/api_service_myconcept/response.dart';
import 'package:auscurator/api_service_myconcept/response_extension.dart';
import 'package:auscurator/machine_iot/model/save_ticket_model.dart';
import 'package:auscurator/machine_iot/util.dart';
import 'package:auscurator/provider/all_provider.dart';
import 'package:auscurator/util/shared_util.dart';
import 'package:flutter/material.dart';

class TicketRepository {
  Future<bool> getAssetEquipmentList(
    BuildContext context,
  ) async {
    final cId = SharedUtil().getcompanyId;
    final bId = SharedUtil().getBuId;
    final pId = SharedUtil().getPlantId;
    final dId = SharedUtil().getDepartmentId;
    final LId = SharedUtil().getLocationId;

    final input = {
      "asset_id": "",
      "company_id": cId == "0" ? "" : cId,
      "bu_id": bId == "0" ? "" : bId,
      "plant_id": pId == '0' ? "" : pId,
      "department_id": dId == "0" ? "" : dId,
      "location_id": LId == "0" ? "" : LId,
      "asset_group_id": "",
      "status": "active"
    };
    ticketProvider.isLoading = true;
    ResponseData response =
        await APIService().post(context, "assetLists/", body: input);
    ticketProvider.isLoading = false;
    if (response.hasError(context)) return false;
    final jsonObj = response.data;
    ticketProvider.listEquipmentData = jsonObj["assetLists"];

    // String message = response.data['message'] ?? '';

    // if (message.isNotEmpty) showMessage1(message);
    return true;
  }

  Future<bool> saveTicket(
    BuildContext context, {
    required String assetGroupId,
    required String assetId,
    required String breakdownCategoryId,
    required String breakdownSubCategoryId,
    required String assetStatus,
    required String priorityId,
    required String userLoginId,
    required String comment,
  }) async {
    final cId = SharedUtil().getcompanyId;
    final bId = SharedUtil().getBuId;
    final pId = SharedUtil().getPlantId;
    final dId = SharedUtil().getDepartmentId;
    final LId = SharedUtil().getLocationId;
    final LoginId = SharedUtil().getLoginId;
    final body = {
      'company_id': cId == '0' ? '' : cId,
      'bu_id': bId == '0' ? '' : bId,
      'plant_id': pId == '0' ? '' : pId,
      'department_id': dId == '0' ? '' : dId,
      'location_id': LId == '0' ? '' : LId,
      'asset_group_id': assetGroupId,
      'asset_id': assetId,
      'breakdown_category_id': breakdownCategoryId,
      'breakdown_subcategory_id': breakdownSubCategoryId,
      'asset_status': assetStatus,
      'priority': priorityId,
      'user_login_id': LoginId,
      'comment': comment
    };
    logger.f(body);
    ticketProvider.isLoading = true;
    ResponseData response =
        await APIService().post(context, "create_ticket/", body: body);
    ticketProvider.isLoading = false;
    logger.f(response.data);

    if (response.hasError(context)) return false;
    final jsonObj = response.data;
    ticketProvider.saveTicketData = SaveTicketModel.fromJson(jsonObj);
    String message = response.data['message'] ?? '';
    if (message.isNotEmpty)
      showMessage(context: context, isError: false, responseMessage: message);
    return true;
  }
}
