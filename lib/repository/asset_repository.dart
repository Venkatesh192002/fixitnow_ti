import 'package:auscurator/api_service_myconcept/api_service_new.dart';
import 'package:auscurator/api_service_myconcept/keys.dart';
import 'package:auscurator/api_service_myconcept/response.dart';
import 'package:auscurator/api_service_myconcept/response_extension.dart';
import 'package:auscurator/machine_iot/section_bottom_sheet/widget/equipment_spinner_bloc/model/AssetModel.dart';
import 'package:auscurator/model/AssetGroupModel.dart';
import 'package:auscurator/model/asset_engineer_id.dart';
import 'package:auscurator/model/asset_head_engineer_model.dart';
import 'package:auscurator/provider/all_provider.dart';
import 'package:auscurator/util/shared_util.dart';
import 'package:flutter/material.dart';

class AssetRepository {
  Future<bool> getListOfEquipmentGroup(BuildContext context) async {
    final cId = SharedUtil().getcompanyId;
    final bId = SharedUtil().getBuId;
    final pId = SharedUtil().getPlantId;
    final dId = SharedUtil().getDepartmentId;
    final LId = SharedUtil().getLocationId;
    print('company -> $cId');
    print('bu -> $bId');
    print('plant -> $pId');
    print('department -> $dId');
    print('Location -> $LId');

    final input = {
      "asset_group_id": "",
      "company_id": cId == "0" ? "" : cId,
      "bu_id": bId == "0" ? "" : bId,
      "plant_id": pId == '0' ? "" : pId,
      "department_id": dId == "0" ? "" : dId,
      "location_id": LId == "0" ? "" : LId,
      "status": "active"
    };

    assetProvider.isLoading = true;
    ResponseData response =
        await APIService().post(context, "asset_groupLists/", body: input);
    assetProvider.isLoading = false;
    if (response.hasError(context)) return false;
    final jsonObj = response.data;
    assetProvider.assetGroupData = AssetGroupModel.fromJson(jsonObj);
    // logger.i(assetProvider.assetGroupData?.toJson());
    // String message = response.data['message'] ?? '';
    // if (message.isNotEmpty)
    //   showMessage(context: context, isError: true, responseMessage: message);
    return true;
  }

  Future<bool> getListOfEquipment(BuildContext context,
      {required String assetGroupId}) async {
    final cId = SharedUtil().getcompanyId;
    final bId = SharedUtil().getBuId;
    final pId = SharedUtil().getPlantId;
    final dId = SharedUtil().getDepartmentId;
    final LId = SharedUtil().getLocationId;
    final empType = SharedUtil().getEmployeeType;

    print('company -> $cId');
    print('bu -> $bId');
    print('plant -> $pId');
    print('department -> $dId');
    print('Location -> $LId');

    List deptId = [];
    if (empType == "Head/Engineer" || empType == "Department Head") {
      List<AssignDepartmentHead> headDeptId =
          assetProvider.assetHeadEngId?.assignDepartmentHead ?? [];
      for (var element in headDeptId) {
        deptId.add(element.departmentId);
      }
    }

    final input = {
      "asset_id": "",
      "company_id": cId == "0" ? "" : cId,
      "bu_id": bId == "0" ? "" : bId,
      "plant_id": pId == '0' ? "" : pId,
      "department_id": dId == "0"
          ? ""
          : empType == 'Engineer'
              ? "${assetProvider.assetEngId?.departmentEngineerLists?[0].departmentId}"
              : empType == "Head/Engineer" || empType == "Department Head"
                  ? "${deptId}"
                  : dId,
      "location_id": LId == "0" ? "" : LId,
      "asset_group_id": assetGroupId,
      "status": "active"
    };

    assetProvider.isLoading = true;
    ResponseData response =
        await APIService().post(context, "assetLists/", body: input);

    assetProvider.isLoading = false;
    if (response.hasError(context)) return false;
    final jsonObj = response.data;

    assetProvider.assetModelData = AssetModel.fromJson(jsonObj);

    // String message = response.data['message'] ?? '';
    // if (message.isNotEmpty)
    //   showMessage(context: context, isError: true, responseMessage: message);
    return true;
  }

  Future<bool> getAssetEngineerIds(BuildContext context) async {
    final LoginId = SharedUtil().getLoginId;

    final input = {"employee_id": LoginId, "status": "active"};
    // logger.d(input);
    assetProvider.isLoading = true;
    ResponseData response = await APIService()
        .post(context, "department_engineerLists/", body: input);
    assetProvider.isLoading = false;
    if (response.hasError(context)) return false;
    final jsonObj = response.data;
    // logger.d(jsonObj);

    assetProvider.assetEngId = AssetEngIdModel.fromJson(jsonObj);

    // String message = response.data['message'] ?? '';
    // if (message.isNotEmpty)
    //   showMessage(context: context, isError: true, responseMessage: message);
    return true;
  }

  Future<bool> getAssetHeadEngineerIds(BuildContext context) async {
    final LoginId = SharedUtil().getLoginId;

    final input = {"user_login_id": LoginId};
    ;
    logger.d(input);

    assetProvider.isLoading = true;
    ResponseData response = await APIService()
        .post(context, "get_assign_department_head/", body: input);
    assetProvider.isLoading = false;
    if (response.hasError(context)) return false;
    final jsonObj = response.data;

    assetProvider.assetHeadEngId = AssetHeadIdModel.fromJson(jsonObj);

    // String message = response.data['message'] ?? '';
    // if (message.isNotEmpty)
    //   showMessage(context: context, isError: true, responseMessage: message);
    return true;
  }
}
