// ignore_for_file: await_only_futures, use_build_context_synchronously
import 'package:auscurator/api_service_myconcept/api_helper.dart';
import 'package:auscurator/api_service_myconcept/app_strings.dart';
import 'package:auscurator/api_service_myconcept/keys.dart';
import 'package:auscurator/api_service_myconcept/response.dart';
import 'package:auscurator/repository/info_repository.dart';
import 'package:auscurator/util/shared_util.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

options(String prefix) {
  String url = '$prefix';
  if (!url.endsWith('/')) url += '/';
  return BaseOptions(
      baseUrl: url,
      headers: setHeaders(),
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20));
}

Map<String, String> setHeaders() {
  return {
    'AppCode': AppStrings.appName,
    'Accept': "application/json",
    'Authorization': "Bearer ",
  };
}

class APIService {
  final String prefixUrl;
  Dio dio = Dio();
  APIService({this.prefixUrl = ''}) {
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
        baseUrl = "https://backenddevcmms.auswegprime.com/";
        // baseUrl = "https://backendfixitnow.auswegprime.com/";
      }

      return baseUrl;
    }

    dio.options = options(_getBaseUrl());
    dio.interceptors.add(dioLogger);
  }

// post call
  Future<ResponseData> post(BuildContext context, String url,
      {body, params, bool isAuth = false}) async {
    // while (true) {
    // if (!await InfoRepository().checkInternetConnection()) {
    //   // Wait for a moment before retrying
    //   await Future.delayed(const Duration(seconds: 3));
    //   continue; // Continue the loop to check for internet connection again
    // }
    try {
      var response = await dio.post(url,
          data: FormData.fromMap(body), queryParameters: params);
      // logger.i(response);
      // logger.i(body);
      return APIHelper().httpErrorHandle(context, response: response);
    } on DioException catch (e) {
      return APIHelper().httpErrorHandle(context, response: e.response);
    }
    // }
  }

  //get call
  Future get(BuildContext context, String url,
      {body, params, bool isAuth = false}) async {
    // while (true) {
    //   if (!await InfoRepository().checkInternetConnection()) {
    //     // Wait for a moment before retrying
    //     await Future.delayed(const Duration(seconds: 3));
    //     continue; // Continue the loop to check for internet connection again
    //   }
    try {
      var response = await dio.get(url, data: body, queryParameters: params);
      return APIHelper().httpErrorHandle(context, response: response);
    } on DioException catch (e) {
      return APIHelper().httpErrorHandle(context, response: e.response);
    }
    // }
  }

  // put call
  Future put(BuildContext context, String url,
      {body, params, cusUrl, bool isAuth = false}) async {
    while (true) {
      if (!await InfoRepository().checkInternetConnection()) {
        // Wait for a moment before retrying
        await Future.delayed(const Duration(seconds: 3));
        continue; // Continue the loop to check for internet connection again
      }
      try {
        var response = await dio.put(url, data: body, queryParameters: params);
        return APIHelper().httpErrorHandle(context, response: response);
      } on DioException catch (e) {
        if (e.response == null) return;
        return APIHelper().httpErrorHandle(context, response: e.response);
      }
    }
  }

  //delete call
  Future delete(BuildContext context, String url,
      {body, params, bool isAuth = false}) async {
    while (true) {
      if (!await InfoRepository().checkInternetConnection()) {
        // Wait for a moment before retrying
        await Future.delayed(const Duration(seconds: 3));
        continue; // Continue the loop to check for internet connection again
      }
      try {
        var response =
            await dio.delete(url, data: body, queryParameters: params);
        return APIHelper().httpErrorHandle(context, response: response);
      } on DioException catch (e) {
        if (e.response == null) return;
        return APIHelper().httpErrorHandle(context, response: e.response);
      }
    }
  }
}
