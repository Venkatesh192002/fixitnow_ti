import 'package:auscurator/api_service_myconcept/api_helper.dart';
import 'package:auscurator/api_service_myconcept/api_service_new.dart';
import 'package:auscurator/api_service_myconcept/response.dart';
import 'package:auscurator/api_service_myconcept/response_extension.dart';
import 'package:auscurator/model/SpareEditListModel.dart';
import 'package:auscurator/model/SpareListsModel.dart';
import 'package:auscurator/provider/all_provider.dart';
import 'package:auscurator/util/shared_util.dart';
import 'package:flutter/material.dart';

class SpareRepository {
  // APIService get _api => APIService(prefixUrl: _prefixUrl);

  Future<bool> getTicketSpareList(BuildContext context,
      {required String ticketId}) async {
    provdSpare.isLoading = true;
    ResponseData response = await APIService()
        .post(context, "get_ticket_spare_data/", body: {'ticket_id': ticketId});
    provdSpare.isLoading = false;

    if (response.hasError(context)) return false;
    final jsonObj = response.data;
    provdSpare.ticketData = SpareEditListsModel.fromJson(jsonObj);

    String message = response.data['message'] ?? '';

    if (message.isNotEmpty) showMessage1(message);
    return true;
  }

  Future<bool> spareLists(
    BuildContext context, {
    required String assetGroupId,
    required String assetId,
  }) async {
    final pId = SharedUtil().getPlantId;
    final dId = SharedUtil().getDepartmentId;
    final body = {
      'plant_id': pId == '0' ? '' : pId,
      'department_id': dId == '0' ? '' : dId,
      'asset_group_id': assetGroupId,
      "asset_id": assetId,
      'type': "all"
    };
    provdSpare.isLoading = true;
    ResponseData response =
        await APIService().post(context, "get_spares_lists/", body: body);
    provdSpare.isLoading = false;

    if (response.hasError(context)) return false;
    final jsonObj = response.data;

    provdSpare.spareListData = SpareListsModel.fromJson(jsonObj);

    String message = response.data['message'] ?? '';

    if (message.isNotEmpty) showMessage1(message);
    return true;
  }
}
