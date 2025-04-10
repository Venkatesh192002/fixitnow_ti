import 'dart:convert';
import 'package:auscurator/api_service_myconcept/keys.dart';
import 'package:auscurator/machine_iot/model/break_down_list_model.dart';
import 'package:auscurator/machine_iot/model/engineer_model.dart';
import 'package:auscurator/machine_iot/model/save_ticket_model.dart';
import 'package:auscurator/machine_iot/model/ticket_detail_model.dart';
import 'package:auscurator/machine_iot/section_bottom_sheet/widget/equipment_spinner_bloc/model/AssetModel.dart';
import 'package:auscurator/model/AssetGroupModel.dart';
import 'package:auscurator/model/BreakdownTicketCountsModel.dart';
import 'package:auscurator/model/BreakdownTicketModel.dart';
import 'package:auscurator/model/CategoryBasedModel.dart';
import 'package:auscurator/model/DepartmentListsModel.dart';
import 'package:auscurator/model/EmployeeListModel.dart';
import 'package:auscurator/model/MTTRListModel.dart';
import 'package:auscurator/model/MTTRUpdateListModel.dart';
import 'package:auscurator/model/MainCategoryModel.dart';
import 'package:auscurator/model/MappedSpareListModel.dart';
import 'package:auscurator/model/OpenCompletedModel.dart';
import 'package:auscurator/model/SaveTicketStatusModel.dart';
import 'package:auscurator/model/SpareEditListModel.dart';
import 'package:auscurator/model/SpareListsModel.dart';
import 'package:auscurator/model/SubCategoryModel.dart';
import 'package:auscurator/model/TicketDetailModel.dart';
import 'package:auscurator/model/asset_head_engineer_model.dart';
import 'package:auscurator/model/engineer_overall_model.dart';
import 'package:auscurator/model/login_model.dart';
import 'package:auscurator/provider/all_provider.dart';
import 'package:auscurator/util/shared_util.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ApiService {
  String _getBaseUrl() {
    var baseUrl = "";

    final isIpOneCheck = SharedUtil().IpOneCheckStatus;
    final isIpTwoCheck = SharedUtil().IpTwoCheckStatus;
    final ipOneBaseUrl = SharedUtil().getIpOne;
    final ipTwoBaseUrl = SharedUtil().getIpTwo;

    if (isIpOneCheck == true && ipOneBaseUrl.isNotEmpty) {
      baseUrl = ipOneBaseUrl;
    }

    if (isIpTwoCheck == true && ipTwoBaseUrl.isNotEmpty) {
      baseUrl = ipTwoBaseUrl;
    }

    // If both base URLs are empty, return the default URL
    if (baseUrl.isEmpty) {
      baseUrl = "https://cmmstestapi.tiindia.co.in/";
      // baseUrl = "https://cmmsapi.tiindia.co.in/";
      // baseUrl = "https://backendfixitnow.auswegprime.com/";
    }

    return baseUrl;
  }

  Future<LoginModel> getLoginDetail(
    String userName,
    String userPassword,
    String token,
  ) async {
    final userInput = {
      "username": userName,
      "password": userPassword,
      "user_id": token
    };
    logger.i("${_getBaseUrl()}${userInput}");
    try {
      final responseBody = await http.post(
        Uri.parse("${_getBaseUrl()}loginformmodel/"),
        body: userInput,
      );

      if (responseBody.statusCode == 200) {
        print('Response: ${responseBody.body}'); // Log the response
        final dynamic jsonData = json.decode(responseBody.body);

        // Check if the response is a list or a map
        if (jsonData is List) {
          print('Response is a list. Handling accordingly.');
          if (jsonData.isNotEmpty) {
            // Cast the first element of the list to Map<String, dynamic>
            final loginData =
                LoginModel.fromJson(jsonData[0] as Map<String, dynamic>);
            layoutProvider.loginData = LoginModel.fromJson(jsonData[0]);
            return loginData;
          } else {
            throw "Empty response list";
          }
        } else if (jsonData is Map) {
          print('Response is a map.');
          // Cast the map to Map<String, dynamic>
          final loginData =
              LoginModel.fromJson(jsonData as Map<String, dynamic>);
          return loginData;
        } else {
          throw "Unexpected response format";
        }
      } else {
        print('login_5');
        throw "Login error, status code: ${responseBody.statusCode}";
      }
    } catch (e) {
      print('login_6 $e');
      throw "Login error: $e";
    }
  }

//  Dashboard
//counts
  Future<BreakdownTicketCountsModel> DashboardCounts(
      {required String from_date,
      required String to_date,
      required String status}) async {
    final cId = SharedUtil().getcompanyId;
    final bId = SharedUtil().getBuId;
    final pId = SharedUtil().getPlantId;
    final dId = SharedUtil().getDepartmentId;
    final LId = SharedUtil().getLocationId;
    final LoginId = SharedUtil().getLoginId;
    print('company -> $cId');
    print('bu -> $bId');
    print('plant -> $pId');
    print('department -> $dId');
    print('Location -> $LId');
    print('Loginid -> $LoginId');
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

    try {
      print('count ${_getBaseUrl()}');
      // Send the request with proper headers and body encoding
      final response = await http.post(
        Uri.parse('${_getBaseUrl()}breakdown_reportLists/'),

        body: body, // Encode the body as JSON
      );

      if (response.statusCode == 200) {
        // Decode the response body
        final jsonObj = json.decode(response.body);

        // Check if the response is a list
        if (jsonObj is List) {
          // Access the first item in the list and ensure it's a Map
          if (jsonObj.isNotEmpty && jsonObj[0] is Map<String, dynamic>) {
            final firstItem = jsonObj[0] as Map<String, dynamic>; // Cast to Map
            final parsedModel = BreakdownTicketCountsModel.fromJson(firstItem);
            print('Parsed Model: ${parsedModel.toJson()}');
            return parsedModel;
          } else {
            print('List is empty or does not contain valid data');
            return BreakdownTicketCountsModel.fromError(
                errorMessage: 'No data available', errorStatus: true);
          }
        } else if (jsonObj is Map<String, dynamic>) {
          // If it's a map (not a list), handle it accordingly
          final parsedModel = BreakdownTicketCountsModel.fromJson(jsonObj);
          print('Parsed Model: ${parsedModel.toJson()}');
          return parsedModel;
        } else {
          print('Unexpected response format');
          return BreakdownTicketCountsModel.fromError(
              errorStatus: true, errorMessage: 'Unexpected response format');
        }
      }

      print('Response Status Code: ${response.statusCode}');
      return BreakdownTicketCountsModel.fromError(
          errorStatus: true, errorMessage: 'Please check network..!');
    } catch (e) {
      print('Error: $e');
      return BreakdownTicketCountsModel.fromError(
          errorStatus: true, errorMessage: e.toString());
    }
  }

  //open vs completed
  Future<OpenCompletedModel> OpenCompleted(
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

    try {
      // Send the request with proper headers and body encoding
      final response = await http.post(
        Uri.parse('${_getBaseUrl()}breakdown_reportLists/'),
        body: body, // Encode the body as JSON
      );

      if (response.statusCode == 200) {
        // Decode the response body
        final jsonObj = json.decode(response.body);

        // Check if the response is a list
        if (jsonObj is List) {
          // Access the first item in the list and ensure it's a Map
          if (jsonObj.isNotEmpty && jsonObj[0] is Map<String, dynamic>) {
            final firstItem = jsonObj[0] as Map<String, dynamic>; // Cast to Map
            final parsedModel = OpenCompletedModel.fromJson(firstItem);
            print('Parsed Model Open:  ${parsedModel.toJson()}');
            return parsedModel;
          } else {
            print('List is empty or does not contain valid data');
            return OpenCompletedModel.fromError(
                errorMessage: 'No data available', errorStatus: true);
          }
        } else if (jsonObj is Map<String, dynamic>) {
          // If it's a map (not a list), handle it accordingly
          final parsedModel = OpenCompletedModel.fromJson(jsonObj);
          print('Parsed Model Open: ${parsedModel.toJson()}');
          return parsedModel;
        } else {
          print('Unexpected response format');
          return OpenCompletedModel.fromError(
              errorStatus: true, errorMessage: 'Unexpected response format');
        }
      }

      print('Response Status Code: ${response.statusCode}');
      return OpenCompletedModel.fromError(
          errorStatus: true, errorMessage: 'Please check network..!');
    } catch (e) {
      print('Error: $e');
      return OpenCompletedModel.fromError(
          errorStatus: true, errorMessage: e.toString());
    }
  }

  //Category Based Breakdown
  Future<CategoryBasedModel> CategoryBased(
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

    try {
      // Send the request with proper headers and body encoding
      final response = await http.post(
        Uri.parse('${_getBaseUrl()}breakdown_reportLists/'),
        body: body, // Encode the body as JSON
      );

      if (response.statusCode == 200) {
        // Decode the response body
        final jsonObj = json.decode(response.body);

        // Check if the response is a list
        if (jsonObj is List) {
          // Access the first item in the list and ensure it's a Map
          if (jsonObj.isNotEmpty && jsonObj[0] is Map<String, dynamic>) {
            final firstItem = jsonObj[0] as Map<String, dynamic>; // Cast to Map
            final parsedModel = CategoryBasedModel.fromJson(firstItem);
            print('Parsed Model Category: ${parsedModel.toJson()}');
            return parsedModel;
          } else {
            print('List is empty or does not contain valid data');
            return CategoryBasedModel.fromError(
                errorMessage: 'No data available', errorStatus: true);
          }
        } else if (jsonObj is Map<String, dynamic>) {
          // If it's a map (not a list), handle it accordingly
          final parsedModel = CategoryBasedModel.fromJson(jsonObj);
          print('Parsed Model Category: ${parsedModel.toJson()}');
          return parsedModel;
        } else {
          print('Unexpected response format');
          return CategoryBasedModel.fromError(
              errorStatus: true, errorMessage: 'Unexpected response format');
        }
      }

      print('Response Status Code: ${response.statusCode}');
      return CategoryBasedModel.fromError(
          errorStatus: true, errorMessage: 'Please check network..!');
    } catch (e) {
      print('Error: $e');
      return CategoryBasedModel.fromError(
          errorStatus: true, errorMessage: e.toString());
    }
  }

//   //cmms api integration
  Future<AssetGroupModel> getListOfEquipmentGroup() async {
    logger.e("${_getBaseUrl()}asset_groupLists/");
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
      "asset_group_id": "",
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
      "status": "active"
    };
    // logger.wtf(input);

    try {
      final response = await http
          .post(Uri.parse('${_getBaseUrl()}asset_groupLists/'), body: input);

      if (response.statusCode == 200) {
        final jsonObj = json.decode(response.body);
        final list = jsonObj[0];
        // logger.wtf(list);

        return AssetGroupModel.fromJson(list);
      }

      if (response.statusCode != 200) {
        print('checking:-${response.statusCode}');
        return AssetGroupModel.fromError(
            errorStatus: true, errorMessage: 'Please check network..!');
      }
    } catch (e) {
      return AssetGroupModel.fromError(
          errorStatus: true, errorMessage: e.toString());
    }

    return AssetGroupModel.fromError(
        errorStatus: true, errorMessage: 'Somthink went wrong..!');
  }

  Future<AssetModel> getListOfEquipment({required String assetGroupId}) async {
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

    // logger.w(input);

    try {
      final response = await http.post(Uri.parse('${_getBaseUrl()}assetLists/'),
          body: input);

      if (response.statusCode == 200) {
        final jsonObj = json.decode(response.body);
        logger.w(jsonObj);
        final list = jsonObj[0];

        return AssetModel.fromJson(list);
      }

      if (response.statusCode != 200) {
        print('checking:-${response.statusCode}');
        return AssetModel.fromError(
            errorStatus: true, errorMessage: 'Please check network..!');
      }
    } catch (e) {
      return AssetModel.fromError(
          errorStatus: true, errorMessage: e.toString());
    }

    return AssetModel.fromError(
        errorStatus: true, errorMessage: 'Somthink went wrong..!');
  }

  Future<MainCategoryModel> getListOfIssue() async {
    try {
      final body = {
        'breakdown_category_id': "",
        'company_id': '',
        'status': "active"
      };

      final response = await http.post(
          Uri.parse('${_getBaseUrl()}breakdown_categoryLists/'),
          body: body);

      if (response.statusCode == 200) {
        final jsonObj = json.decode(response.body);
        final list = jsonObj[0];
        return MainCategoryModel.fromJson(list);
      }

      if (response.statusCode != 200) {
        print('checking:-${response.statusCode}');
        return MainCategoryModel.fromError(
            errorStatus: true, errorMessage: 'Please check network..!');
      }
    } catch (e) {
      return MainCategoryModel.fromError(
          errorStatus: true, errorMessage: e.toString());
    }

    return MainCategoryModel.fromError(
        errorStatus: true, errorMessage: 'Somthink went wrong..!');
  }

  Future<SubCategoryModel> getListOfBreadownSub() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? breakdownCategoryId =
        prefs.getString('breakdown_category_id') ?? "";
    String? assetGroupid = prefs.getString('asset_group_id') ?? "";

    try {
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

      final response = await http.post(
          Uri.parse('${_getBaseUrl()}breakdown_assignmentLists/'),
          body: body);

      if (response.statusCode == 200) {
        final jsonObj = json.decode(response.body);
        final list = jsonObj[0];
        return SubCategoryModel.fromJson(list);
      }

      if (response.statusCode != 200) {
        print('checking:-${response.statusCode}');
        return SubCategoryModel.fromError(
            errorStatus: true, errorMessage: 'Please check network..!');
      }
    } catch (e) {
      return SubCategoryModel.fromError(
          errorStatus: true, errorMessage: e.toString());
    }

    return SubCategoryModel.fromError(
        errorStatus: true, errorMessage: 'Somthing went wrong..!');
  }

  Future<SaveTicketModel> saveTicket({
    required String assetGroupId,
    required String assetId,
    required String breakdownCategoryId,
    required String assetStatus,
    required String priorityId,
    required String userLoginId,
    required String comment,
  }) async {
    try {
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
        'breakdown_subcategory_id': breakdownCategoryId,
        'asset_status': assetStatus,
        'priority': priorityId,
        'user_login_id': LoginId,
        'comment': comment
      };

      // logger.wtf(body);

      final response = await http
          .post(Uri.parse('${_getBaseUrl()}create_ticket/'), body: body);

      if (response.statusCode == 200) {
        final jsonObj = json.decode(response.body);

        // Handle list response
        if (jsonObj is List && jsonObj.isNotEmpty) {
          return SaveTicketModel.fromJson(jsonObj[0] as Map<String, dynamic>);
        }

        // Handle map response
        else if (jsonObj is Map) {
          return SaveTicketModel.fromJson(jsonObj as Map<String, dynamic>);
        } else {
          return SaveTicketModel.fromError(
              isErrorThrown: true, errorMessage: 'Unexpected response format.');
        }
      }

      print('checking:-${response.statusCode}');
      return SaveTicketModel.fromError(
          isErrorThrown: true, errorMessage: 'Please check network..!');
    } catch (e) {
      print(e.toString());
      return SaveTicketModel.fromError(
          isErrorThrown: true, errorMessage: e.toString());
    }
  }

  Future<BreakkdownTicketModel> getBreakDownStatusList(
      {required String breakdown_status,
      required String period,
      required String from_date,
      required String to_date,
      required String user_login_id}) async {
    try {
      final LoginId = SharedUtil().getLoginId;
      final body = {
        'ticket_id': '',
        'breakdown_status': breakdown_status,
        'period': period,
        'from_date': from_date,
        'to_date': to_date,
        'user_login_id': LoginId
      };
      logger.i(body);
      final response = await http.post(
          Uri.parse('${_getBaseUrl()}get_breakdown_detail_list/'),
          body: body);
      if (response.statusCode == 200) {
        final jsonObj = json.decode(response.body);
        final list = jsonObj[0];
        return BreakkdownTicketModel.fromJson(list);
      }
      if (response.statusCode != 200) {
        return BreakkdownTicketModel.fromError(
            isErrorThrown: true,
            errorMessage: 'Please check network..! ${response.statusCode}');
      }
    } catch (e) {
      return BreakkdownTicketModel.fromError(
          isErrorThrown: true, errorMessage: e.toString());
    }
    return BreakkdownTicketModel.fromError(
        isErrorThrown: true, errorMessage: 'Somthink went wrong..!');
  }

  Future<TicketDetailModel> getBreakDownDetailList({
    required String ticket_no,
    String? date,
    String? fromDate,
  }) async {
    try {
      final LoginId = SharedUtil().getLoginId;
      print('login_id->$LoginId');
      final body = {
        'ticket_id': ticket_no,
        'breakdown_status': '',
        'period': date ?? "",
        'from_date': fromDate ?? "",
        'to_date': '',
        'user_login_id': LoginId
      };
      // logger.w(body);

      final response = await http.post(
          Uri.parse('${_getBaseUrl()}get_breakdown_detail_list/'),
          body: body);

      if (response.statusCode == 200) {
        final jsonObj = json.decode(response.body);
        final list = jsonObj[0];
        // logger.w(list);

        return TicketDetailModel.fromJson(list);
      }
      if (response.statusCode != 200) {
        return TicketDetailModel.fromError(
            isErrorThrown: true,
            errorMessage: 'Please check network..! ${response.statusCode}');
      }
    } catch (e) {
      return TicketDetailModel.fromError(
          isErrorThrown: true, errorMessage: e.toString());
    }
    return TicketDetailModel.fromError(
        isErrorThrown: true, errorMessage: 'Somthink went wrong..!');
  }

  Future<BreakDownListModel> getBreakDownList(
      {required String selectedStatusId}) async {
    print('breakdown_list:- $selectedStatusId');
    final body = {'tab_value': selectedStatusId, 'user_login_id': '1'};

    try {
      final response = await http.post(
          Uri.parse('${_getBaseUrl()}get_break_down_ticket_list/'),
          body: body);

      if (response.statusCode == 200) {
        final jsonObj = json.decode(response.body);
        final list = jsonObj[0];
        return BreakDownListModel.fromJson(list);
      }

      if (response.statusCode != 200) {
        print('checking:-${response.statusCode}');
        return BreakDownListModel.fromError(
            isErrorThrown: true, errormessage: 'Please check network..!');
      }
    } catch (e) {
      return BreakDownListModel.fromError(
          isErrorThrown: true, errormessage: e.toString());
    }

    return BreakDownListModel.fromError(
        isErrorThrown: true, errormessage: 'Somthink went wrong..!');
  }

  Future<EmployeeListModel> getEmployeeList({required String userAvail}) async {
    final cId = SharedUtil().getcompanyId;
    final bId = SharedUtil().getBuId;
    final pId = SharedUtil().getPlantId;
    List companyId = jsonDecode(cId ?? "");
    String formattedIds = companyId.join(',');
    final body = {
      'employee_id': '',
      'company_id': cId == '0' ? '' : formattedIds,
      'bu_id': bId == '0' ? '' : bId,
      'plant_id': pId == '0' ? '' : pId,
      'is_engineer': 'yes',
      'user_availability': userAvail,
      'status': 'active'
    };
    try {
      final response = await http
          .post(Uri.parse('${_getBaseUrl()}employeeLists/'), body: body);

      if (response.statusCode == 200) {
        final jsonObj = json.decode(response.body);
        final list = jsonObj[0];
        return EmployeeListModel.fromJson(list);
      }

      if (response.statusCode != 200) {
        return EmployeeListModel.fromError('Please check network..!');
      }
    } catch (e) {
      return EmployeeListModel.fromError(e.toString());
    }

    return EmployeeListModel.fromError('Somthink went wrong..!');
  }

  Future<EngineerOverallListModel> getEngineerOverallList(
      {required String companyId,
      required String buId,
      required String plantId,
      required String deptId}) async {
    final body = {
      'company_id': companyId,
      'bu_id': buId,
      'plant_id': plantId,
      'department_id': deptId,
      'status': 'active'
    };
    // logger.e(body);
    try {
      final response = await http.post(
          Uri.parse('${_getBaseUrl()}department_engineerLists/'),
          body: body);

      if (response.statusCode == 200) {
        final jsonObj = json.decode(response.body);
        final list = jsonObj[0];
        // logger.e(list);

        return EngineerOverallListModel.fromJson(list);
      }

      if (response.statusCode != 200) {
        return EngineerOverallListModel.fromError(
            isErrorThrown: true, errorMessage: 'Please check network..!');
      }
    } catch (e) {
      return EngineerOverallListModel.fromError(
          isErrorThrown: true, errorMessage: e.toString());
    }

    return EngineerOverallListModel.fromError(
        isErrorThrown: true, errorMessage: 'Somthink went wrong..!');
  }

  Future<TicketDetail> getTicketDetail({required String ticketNo}) async {
    final body = {
      'ticket_id': ticketNo,
      'group_by': 'ticket',
      'report_type': 'detail'
    };

    try {
      final response = await http.post(
          Uri.parse('${_getBaseUrl()}breakdown_reportLists/'),
          body: body);

      if (response.statusCode == 200) {
        final jsonObj = json.decode(response.body);
        final list = jsonObj[0];
        return TicketDetail.fromJson(list);
      }

      if (response.statusCode != 200) {
        return TicketDetail.fromError(
            isErrorThrown: true, errorMessage: 'Please check network..!');
      }
    } catch (e) {
      return TicketDetail.fromError(
          isErrorThrown: true, errorMessage: e.toString());
    }

    return TicketDetail.fromError(
        isErrorThrown: true, errorMessage: 'Somthing went wrong..!');
  }

  Future<SaveTicketStatusModel> AssignEngineer({
    required String ticketNo,
    required String status_id,
    required String priority,
    required String engineer_id,
    required String assign_type,
    required String downtime_val,
    required String open_comment,
    required String assigned_comment,
    required String accept_comment,
    required String reject_comment,
    required String hold_comment,
    required String pending_comment,
    required String check_out_comment,
    required String completed_comment,
    required String reopen_comment,
    required String reassign_comment,
    required String comment,
  }) async {
    final LoginId = SharedUtil().getLoginId;
    final body = {
      'ticket_id': ticketNo,
      'status_id': status_id,
      'priority': priority,
      'engineer_id': engineer_id,
      'user_login_id': LoginId,
      'assign_type': assign_type,
      'downtime_val': downtime_val,
      'open_comment': open_comment,
      'assigned_comment': assigned_comment,
      'accept_comment': accept_comment,
      'reject_comment': reject_comment,
      'hold_comment': hold_comment,
      'pending_comment': pending_comment,
      'check_out_comment': check_out_comment,
      'completed_comment': completed_comment,
      'reopen_comment': reopen_comment,
      'reassign_comment': reassign_comment,
      'comment': comment
    };

    try {
      final response = await http
          .post(Uri.parse('${_getBaseUrl()}save_ticket_status/'), body: body);
      if (response.statusCode == 200) {
        final jsonObj = json.decode(response.body);
        final list = jsonObj[0];
        return SaveTicketStatusModel.fromJson(list);
      }

      if (response.statusCode != 200) {
        print('checking:-${response.statusCode}');
        return SaveTicketStatusModel.fromError(
            isErrorThrown: true, errorMessage: 'Please check network..!');
      }
    } catch (e) {
      return SaveTicketStatusModel.fromError(
          isErrorThrown: true, errorMessage: e.toString());
    }
    return SaveTicketStatusModel.fromError(
        isErrorThrown: true, errorMessage: 'Somthink went wrong..!');
  }

  Future<SaveTicketStatusModel> TicketAccept({
    required String ticketNo,
    required String status_id,
    required String priority,
    required String assign_type,
    required String downtime_val,
    required String open_comment,
    required String assigned_comment,
    required String accept_comment,
    required String reject_comment,
    required String hold_comment,
    required String pending_comment,
    required String checkin_comment,
    required String check_out_comment,
    required String completed_comment,
    required String reopen_comment,
    required String reassign_comment,
    required String breakdown_category_id,
    required String breakdown_subcategory_id,
    required String comment,
    required String planned_Date,
    required String solution,
    String? isComment,
    abnormality,
  }) async {
    final LoginId = SharedUtil().getLoginId;
    final body = {
      'ticket_id': ticketNo,
      'status_id': status_id,
      'priority': priority,
      'engineer_id': LoginId,
      'user_login_id': LoginId,
      'assign_type': assign_type,
      'downtime_val': downtime_val,
      'open_comment': open_comment,
      'assigned_comment': assigned_comment,
      'accept_comment': accept_comment,
      'reject_comment': reject_comment,
      'hold_comment': hold_comment,
      'pending_comment': pending_comment,
      'check_in_comment': checkin_comment,
      'check_out_comment': check_out_comment,
      'completed_comment': completed_comment,
      'reopen_comment': reopen_comment,
      'reassign_comment': reassign_comment,
      'comment': comment,
      'breakdown_category_id': breakdown_category_id,
      'breakdown_subcategory_id': breakdown_subcategory_id,
      'solution': solution,
      "planned_date": planned_Date,
      "is_comment": isComment ?? "no",
      "abnormality_due_to": abnormality ?? ""
    };
    logger.i(body);

    try {
      final response = await http
          .post(Uri.parse('${_getBaseUrl()}save_ticket_status/'), body: body);
      logger.w(response.body);
      if (response.statusCode == 200) {
        final jsonObj = json.decode(response.body);
        final list = jsonObj[0];
        return SaveTicketStatusModel.fromJson(list);
      }

      if (response.statusCode != 200) {
        print('checking:-${response.statusCode}');
        return SaveTicketStatusModel.fromError(
            isErrorThrown: true, errorMessage: 'Please check network..!');
      }
    } catch (e) {
      return SaveTicketStatusModel.fromError(
          isErrorThrown: true, errorMessage: e.toString());
    }
    return SaveTicketStatusModel.fromError(
        isErrorThrown: true, errorMessage: 'Somthink went wrong..!');
  }

  Future<SaveTicketStatusModel> Ticketcheckin({
    required String ticketNo,
    required String status_id,
    abnormality,
  }) async {
    final LoginId = SharedUtil().getLoginId;
    final body = {
      'ticket_id': ticketNo,
      'status_id': status_id,
      'engineer_id': LoginId,
      'user_login_id': LoginId,
    };
    logger.i(body);

    try {
      final response = await http
          .post(Uri.parse('${_getBaseUrl()}save_ticket_status/'), body: body);
      logger.w(response.body);
      if (response.statusCode == 200) {
        final jsonObj = json.decode(response.body);
        final list = jsonObj[0];
        return SaveTicketStatusModel.fromJson(list);
      }

      if (response.statusCode != 200) {
        print('checking:-${response.statusCode}');
        return SaveTicketStatusModel.fromError(
            isErrorThrown: true, errorMessage: 'Please check network..!');
      }
    } catch (e) {
      return SaveTicketStatusModel.fromError(
          isErrorThrown: true, errorMessage: e.toString());
    }
    return SaveTicketStatusModel.fromError(
        isErrorThrown: true, errorMessage: 'Somthink went wrong..!');
  }

  Future<EmployeeModel> getEngineerList({required String ticketNo}) async {
    final body = {'is_engineer': 'yes', 'status': 'active'};

    try {
      final response = await http
          .post(Uri.parse('${_getBaseUrl()}employeeLists/'), body: body);

      if (response.statusCode == 200) {
        final jsonObj = json.decode(response.body);
        final list = jsonObj[0];
        return EmployeeModel.fromJson(list);
      }

      if (response.statusCode != 200) {
        return EmployeeModel.fromError(
            isErrorThrown: true, errorMessage: 'Please check network..!');
      }
    } catch (e) {
      return EmployeeModel.fromError(
          isErrorThrown: true, errorMessage: e.toString());
    }

    return EmployeeModel.fromError(
        isErrorThrown: true, errorMessage: 'Somthink went wrong..!');
  }

  Future<SaveTicketModel> acceptTicket({
    required String ticketNo,
    required String employeeId,
    required String statusId,
    required String loginId,
    required String downtimeVal,
    required String assignType,
    required String departmentId,
  }) async {
    try {
      final body = {
        'ticket_no': ticketNo,
        'employee_id': employeeId,
        'status_id': statusId,
        'login_id': loginId,
        'downtime_val': downtimeVal,
        'assign_type': assignType,
        'category': departmentId,
      };

      final response = await http
          .post(Uri.parse('${_getBaseUrl()}save_ticket_status/'), body: body);

      if (response.statusCode == 200) {
        final jsonObj = json.decode(response.body);
        final list = jsonObj[0];
        return SaveTicketModel.fromJson(list);
      }

      if (response.statusCode != 200) {
        print('checking:-${response.statusCode}');
        return SaveTicketModel.fromError(
            isErrorThrown: true, errorMessage: 'Please check network..!');
      }
    } catch (e) {
      return SaveTicketModel.fromError(
          isErrorThrown: true, errorMessage: e.toString());
    }

    return SaveTicketModel.fromError(
        isErrorThrown: true, errorMessage: 'Somthink went wrong..!');
  }

  Future<SaveTicketModel> SaveSolutionBank({
    required String ticketNo,
    required String solution_bank,
  }) async {
    final body = {'ticket_id': ticketNo, 'obj': solution_bank};
    logger.w(body);
    try {
      final response = await http
          .post(Uri.parse('${_getBaseUrl()}save_solution_bank/'), body: body);
      if (response.statusCode == 200) {
        final jsonObj = json.decode(response.body);
        final list = jsonObj[0];
        return SaveTicketModel.fromJson(list);
      }

      if (response.statusCode != 200) {
        print('checking:-${response.statusCode}');
        return SaveTicketModel.fromError(
            isErrorThrown: true, errorMessage: 'Please check network..!');
      }
    } catch (e) {
      return SaveTicketModel.fromError(
          isErrorThrown: true, errorMessage: e.toString());
    }
    return SaveTicketModel.fromError(
        isErrorThrown: true, errorMessage: 'Somthink went wrong..!');
  }
  //Spare

  Future<SpareListsModel> SpareLists({
    required String assetGroupId,
    required String assetId,
    required String type,
  }) async {
    final pId = SharedUtil().getPlantId;
    final dId = SharedUtil().getDepartmentId;
    // final body = {
    //   'plant_id': pId == '0' ? '' : pId,
    //   'department_id': dId == '0' ? '' : dId,
    //   'asset_group_id': assetGroupId,
    //   'asset_id': assetId,
    //   'type': type
    // };

    Map<String, dynamic> body = {};
    if (type == "general") {
      body.addAll({
        'plant_id': pId == '0' ? '' : pId,
        'department_id': dId == '0' ? '' : dId,
        'type': type
      });
    } else {
      body.addAll({
        'plant_id': pId == '0' ? '' : pId,
        'department_id': dId == '0' ? '' : dId,
        'asset_group_id': assetGroupId,
        'type': type
      });
    }
    try {
      // Send the request with proper headers and body encoding
      final response = await http.post(
        Uri.parse('${_getBaseUrl()}get_spares_lists/'),
        body: body, // Encode the body as JSON
      );

      if (response.statusCode == 200) {
        // Decode the response body
        final jsonObj = json.decode(response.body);

        // Check if the response is a list
        if (jsonObj is List) {
          // Access the first item in the list and ensure it's a Map
          if (jsonObj.isNotEmpty && jsonObj[0] is Map<String, dynamic>) {
            final firstItem = jsonObj[0] as Map<String, dynamic>; // Cast to Map
            final parsedModel = SpareListsModel.fromJson(firstItem);

            print('Parsed Model: ${parsedModel.toJson()}');
            return parsedModel;
          } else {
            print('List is empty or does not contain valid data');
            return SpareListsModel.fromError(
                isErrorThrown: true, errorMessage: 'No data available');
          }
        } else if (jsonObj is Map<String, dynamic>) {
          // If it's a map (not a list), handle it accordingly
          final parsedModel = SpareListsModel.fromJson(jsonObj);
          print('Parsed Model: ${parsedModel.toJson()}');
          return parsedModel;
        } else {
          print('Unexpected response format');
          return SpareListsModel.fromError(
              isErrorThrown: true, errorMessage: 'Unexpected response format');
        }
      }

      print('Response Status Code: ${response.statusCode}');
      return SpareListsModel.fromError(
          isErrorThrown: true, errorMessage: 'Please check network..!');
    } catch (e) {
      print('Error: $e');
      return SpareListsModel.fromError(
          isErrorThrown: true, errorMessage: e.toString());
    }
  }

  Future<MappedSpareListsModel> MappedSpareLists({
    required String assetGroupId,
    required String assetId,
    required String type,
  }) async {
    final pId = SharedUtil().getPlantId;
    final dId = SharedUtil().getDepartmentId;
    final body = {
      'plant_id': pId == '0' ? '' : pId,
      'department_id': dId == '0' ? '' : dId,
      'asset_group_id': assetGroupId,
      'asset_id': assetId,
      'type': type
    };

    try {
      final response = await http
          .post(Uri.parse('${_getBaseUrl()}get_spares_lists/'), body: body);
      if (response.statusCode == 200) {
        final jsonObj = json.decode(response.body);
        final list = jsonObj[0];
        return MappedSpareListsModel.fromJson(list);
      }

      if (response.statusCode != 200) {
        print('checking:-${response.statusCode}');
        return MappedSpareListsModel.fromError(
            isErrorThrown: true, errorMessage: 'Please check network..!');
      }
    } catch (e) {
      return MappedSpareListsModel.fromError(
          isErrorThrown: true, errorMessage: e.toString());
    }
    return MappedSpareListsModel.fromError(
        isErrorThrown: true, errorMessage: 'Somthink went wrong..!');
  }

  Future<SpareEditListsModel> TicketSpareLists(
      {required String ticketId}) async {
    final body = {'ticket_id': ticketId};

    try {
      // Send the request with proper headers and body encoding
      final response = await http.post(
        Uri.parse('${_getBaseUrl()}get_ticket_spare_data/'),
        body: body, // Encode the body as JSON
      );
      if (response.statusCode == 200) {
        // Decode the response body
        final jsonObj = json.decode(response.body);

        // Check if the response is a list
        if (jsonObj is List) {
          // Access the first item in the list and ensure it's a Map
          if (jsonObj.isNotEmpty && jsonObj[0] is Map<String, dynamic>) {
            final firstItem = jsonObj[0] as Map<String, dynamic>; // Cast to Map
            final parsedModel = SpareEditListsModel.fromJson(firstItem);
            print('Parsed Model: ${parsedModel.toJson()}');
            return parsedModel;
          } else {
            print('List is empty or does not contain valid data');
            return SpareEditListsModel.fromError(
                isErrorThrown: true, errorMessage: 'No data available');
          }
        } else if (jsonObj is Map<String, dynamic>) {
          // If it's a map (not a list), handle it accordingly
          final parsedModel = SpareEditListsModel.fromJson(jsonObj);
          print('Parsed Model: ${parsedModel.toJson()}');
          return parsedModel;
        } else {
          print('Unexpected response format');
          return SpareEditListsModel.fromError(
              isErrorThrown: true, errorMessage: 'Unexpected response format');
        }
      }

      print('Response Status Code: ${response.statusCode}');
      return SpareEditListsModel.fromError(
          isErrorThrown: true, errorMessage: 'Please check network..!');
    } catch (e) {
      print('Error: $e');
      return SpareEditListsModel.fromError(
          isErrorThrown: true, errorMessage: e.toString());
    }
  }

  Future<SpareListsModel> SpareSave({
    required String ticketId,
    required String spares,
  }) async {
    final LoginId = SharedUtil().getLoginId;
    final body = {
      'ticket_id': ticketId,
      'obj': spares,
      'user_login_id': LoginId,
    };

    try {
      final response = await http
          .post(Uri.parse('${_getBaseUrl()}save_spare_data/'), body: body);
      if (response.statusCode == 200) {
        final jsonObj = json.decode(response.body);
        final list = jsonObj[0];
        return SpareListsModel.fromJson(list);
      }

      if (response.statusCode != 200) {
        print('checking:-${response.statusCode}');
        return SpareListsModel.fromError(
            isErrorThrown: true, errorMessage: 'Please check network..!');
      }
    } catch (e) {
      return SpareListsModel.fromError(
          isErrorThrown: true, errorMessage: e.toString());
    }
    return SpareListsModel.fromError(
        isErrorThrown: true, errorMessage: 'Somthink went wrong..!');
  }

  //MTTR
  Future<MTTRListModel> MTTRLists({
    required String assetGroupId,
  }) async {
    final body = {'asset_group_id': assetGroupId};

    try {
      final response =
          await http.post(Uri.parse('${_getBaseUrl()}get_mttr/'), body: body);
      if (response.statusCode == 200) {
        final jsonObj = json.decode(response.body);
        final list = jsonObj[0];
        return MTTRListModel.fromJson(list);
      }

      if (response.statusCode != 200) {
        print('checking:-${response.statusCode}');
        return MTTRListModel.fromError(
            isErrorThrown: true, errorMessage: 'Please check network..!');
      }
    } catch (e) {
      return MTTRListModel.fromError(
          isErrorThrown: true, errorMessage: e.toString());
    }
    return MTTRListModel.fromError(
        isErrorThrown: true, errorMessage: 'Somthink went wrong..!');
  }

  Future<SaveTicketModel> SaveMTTR({
    required String ticketNo,
    required String solution_bank,
  }) async {
    final body = {'ticket_id': ticketNo, 'obj': solution_bank};
    try {
      final response =
          await http.post(Uri.parse('${_getBaseUrl()}save_mttr/'), body: body);
      if (response.statusCode == 200) {
        final jsonObj = json.decode(response.body);
        final list = jsonObj[0];

        return SaveTicketModel.fromJson(list);
      }

      if (response.statusCode != 200) {
        print('checking:-${response.statusCode}');
        return SaveTicketModel.fromError(
            isErrorThrown: true, errorMessage: 'Please check network..!');
      }
    } catch (e) {
      return SaveTicketModel.fromError(
          isErrorThrown: true, errorMessage: e.toString());
    }
    return SaveTicketModel.fromError(
        isErrorThrown: true, errorMessage: 'Somthink went wrong..!');
  }

  Future<MTTRUpdateListModel> MTTRUpdatedLists(
      {required String ticketId}) async {
    final body = {'ticket_id': ticketId};
    try {
      // Send the request with proper headers and body encoding
      final response = await http.post(
        Uri.parse('${_getBaseUrl()}show_mttr_data/'),
        body: body, // Encode the body as JSON
      );

      if (response.statusCode == 200) {
        // Decode the response body
        final jsonObj = json.decode(response.body);
        // Check if the response is a list
        if (jsonObj is List) {
          // Access the first item in the list and ensure it's a Map
          if (jsonObj.isNotEmpty && jsonObj[0] is Map<String, dynamic>) {
            final firstItem = jsonObj[0] as Map<String, dynamic>; // Cast to Map
            final parsedModel = MTTRUpdateListModel.fromJson(firstItem);
            print('Parsed Model: ${parsedModel.toJson()}');
            return parsedModel;
          } else {
            print('List is empty or does not contain valid data');
            return MTTRUpdateListModel.fromError(
                isErrorThrown: true, errorMessage: 'No data available');
          }
        } else if (jsonObj is Map<String, dynamic>) {
          // If it's a map (not a list), handle it accordingly
          final parsedModel = MTTRUpdateListModel.fromJson(jsonObj);
          print('Parsed Model: ${parsedModel.toJson()}');
          return parsedModel;
        } else {
          print('Unexpected response format');
          return MTTRUpdateListModel.fromError(
              isErrorThrown: true, errorMessage: 'Unexpected response format');
        }
      }

      print('Response Status Code: ${response.statusCode}');
      return MTTRUpdateListModel.fromError(
          isErrorThrown: true, errorMessage: 'Please check network..!');
    } catch (e) {
      print('Error: $e');
      return MTTRUpdateListModel.fromError(
          isErrorThrown: true, errorMessage: e.toString());
    }
  }

  Future<DepartmentListsModel> DepartmentLists() async {
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

    try {
      // Send the request with proper headers and body encoding
      final response = await http.post(
        Uri.parse('${_getBaseUrl()}departmentLists/'),
        body: body, // Encode the body as JSON
      );

      if (response.statusCode == 200) {
        // Decode the response body
        final jsonObj = json.decode(response.body);
        // Check if the response is a list
        if (jsonObj is List) {
          // Access the first item in the list and ensure it's a Map
          if (jsonObj.isNotEmpty && jsonObj[0] is Map<String, dynamic>) {
            final firstItem = jsonObj[0] as Map<String, dynamic>; // Cast to Map
            final parsedModel = DepartmentListsModel.fromJson(firstItem);

            print('Parsed Model: ${parsedModel.toJson()}');
            return parsedModel;
          } else {
            print('List is empty or does not contain valid data');
            return DepartmentListsModel.fromError(
                isErrorThrown: true, errorMessage: 'No data available');
          }
        } else if (jsonObj is Map<String, dynamic>) {
          // If it's a map (not a list), handle it accordingly
          final parsedModel = DepartmentListsModel.fromJson(jsonObj);
          print('Parsed Model: ${parsedModel.toJson()}');
          return parsedModel;
        } else {
          print('Unexpected response format');
          return DepartmentListsModel.fromError(
              isErrorThrown: true, errorMessage: 'Unexpected response format');
        }
      }

      print('Response Status Code: ${response.statusCode}');
      return DepartmentListsModel.fromError(
          isErrorThrown: true, errorMessage: 'Please check network..!');
    } catch (e) {
      print('Error: $e');
      return DepartmentListsModel.fromError(
          isErrorThrown: true, errorMessage: e.toString());
    }
  }

  Future<SaveTicketModel> ReAssignEngineer(
      {required String ticketNo,
      required String employee_id,
      required String reassign_comment,
      required String status_id}) async {
    final body = {
      'ticket_no': ticketNo,
      'employee_id': employee_id,
      'status_id': status_id,
      'login_id': '1',
      'reassign_comment': reassign_comment
    };

    try {
      final response = await http
          .post(Uri.parse('${_getBaseUrl()}save_ticket_status/'), body: body);
      if (response.statusCode == 200) {
        final jsonObj = json.decode(response.body);
        final list = jsonObj[0];
        return SaveTicketModel.fromJson(list);
      }

      if (response.statusCode != 200) {
        print('checking:-${response.statusCode}');
        return SaveTicketModel.fromError(
            isErrorThrown: true, errorMessage: 'Please check network..!');
      }
    } catch (e) {
      return SaveTicketModel.fromError(
          isErrorThrown: true, errorMessage: e.toString());
    }
    return SaveTicketModel.fromError(
        isErrorThrown: true, errorMessage: 'Somthink went wrong..!');
  }
}

final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService();
});
