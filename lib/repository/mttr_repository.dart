import 'package:auscurator/api_service_myconcept/api_service_new.dart';
import 'package:auscurator/api_service_myconcept/response.dart';
import 'package:auscurator/api_service_myconcept/response_extension.dart';
import 'package:auscurator/model/MTTRListModel.dart';
import 'package:auscurator/model/MTTRUpdateListModel.dart';
import 'package:auscurator/provider/all_provider.dart';
import 'package:flutter/material.dart';

class MttrRepository {
  Future<bool> MTTRLists(BuildContext context,
      {required String assetGroupId}) async {
    final body = {'asset_group_id': assetGroupId};
    // logger.e(body);
    mttrProvider.isLoading = true;
    ResponseData response =
        await APIService().post(context, "get_mttr/", body: body);
    mttrProvider.isLoading = false;
    if (response.hasError(context)) return false;
    final jsonObj = response.data;
    // logger.d(jsonObj);

    mttrProvider.mttrListsData = MTTRListModel.fromJson(jsonObj);
    return true;
  }

  Future<bool> MTTRUpdatedLists(BuildContext context,
      {required String ticketId}) async {
    final body = {'ticket_id': ticketId};

    mttrProvider.isLoading = true;
    ResponseData response =
        await APIService().post(context, "show_mttr_data/", body: body);
    mttrProvider.isLoading = false;

    if (response.hasError(context)) return false;
    final jsonObj = response.data;
    mttrProvider.mttrUpdateData = MTTRUpdateListModel.fromJson(jsonObj);
    return true;
  }
}
