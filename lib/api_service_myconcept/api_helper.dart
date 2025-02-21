
import 'package:auscurator/api_service_myconcept/keys.dart';
import 'package:auscurator/api_service_myconcept/response.dart';
import 'package:auscurator/widgets/text_widget.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class APIHelper {
  // ResponseData httpErrorHandle({required Response? response}) {
  //   Map<String, dynamic> data = response?.data[0] == null
  //       ? {}
  //       : response!.data[0].toString().isEmpty
  //           ? {}
  //           : response.data[0] is String
  //               ? jsonDecode(response.data[0])
  //               : response.data[0] ?? {};

  //   int statusCode = response?.statusCode ?? 500;

  //   bool isError = response?.data[0]["is_error"] ?? true;
  //   String message = data['message'] ?? '';
  //   if (isError) {
  //     showMessage1(message, duration: const Duration(seconds: 3));
  //   }
  //   // if (statusCode == 500) showMessage('Server or Database not running');
  //   // if (message.isNotEmpty && statusCode == 400) {
  //   //   showMessage(message, duration: const Duration(seconds: 3));
  //   // }
  //   // if (statusCode == 401) {
  //   //   handleUnauthorized();
  //   // }
  //   ResponseData responseData =
  //       ResponseData(data: data, statusCode: statusCode, isError: isError);
  //   return responseData;
  // }

  ResponseData httpErrorHandle(BuildContext context,
      {required Response? response}) {
    final dynamic responseData = response?.data;
    final int statusCode = response?.statusCode ?? 500;


    if (responseData is List && responseData.isNotEmpty) {
      final data = responseData[0];
      bool isError = data["is_error"] ?? true;
      String message = data["message"] ?? 'Unknown error';

      if (isError) {
        showMessage1(message, duration: const Duration(seconds: 3));
      }
    } else if (responseData is Map) {
      // bool isError = responseData["is_error"] ?? true;
      // String message = responseData["message"] ?? 'Unknown error';

      // showMessage(context: context, isError: isError, responseMessage: message);
    } else {
      showMessage1('Unexpected response format',
          duration: const Duration(seconds: 3));
    }

    bool isError = responseData is List
        ? (responseData[0]["is_error"] ?? true)
        : (responseData is Map ? responseData["is_error"] ?? true : true);

    return ResponseData(
      data: responseData is List && responseData.isNotEmpty
          ? responseData[0]
          : (responseData is Map ? responseData : {}),
      statusCode: statusCode,
      isError: isError,
    );
  }

  Future<void> handleUnauthorized() async {
    return storage.delete(key: StorageConstants.accessToken).then((value) {});
  }
}

class StorageConstants {
  static const String accessToken = "ACCESS_TOKEN";
  static const String loginCreds = "login-creds";
  static const String onboarding = "onboarding";
  static const String languageCode = "language_code";
}

showMessage1(String message, {Duration duration = const Duration(seconds: 1)}) {
  return snackbarKey.currentState
    ?..hideCurrentSnackBar
    ..showSnackBar(
      SnackBar(
        duration: duration,
        backgroundColor: Colors.black,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(12),
        content: TextCustom(
          message,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
}

void showMessage2(String message,
    {Duration duration = const Duration(seconds: 1)}) {
  final scaffoldMessenger = snackbarKey.currentState;

  if (scaffoldMessenger != null) {
    scaffoldMessenger
      ..hideCurrentSnackBar() // Optionally hide the current SnackBar
      ..showSnackBar(
        SnackBar(
          duration: duration,
          backgroundColor: Colors.black,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(12),
          content: Text(
            message,
            style: TextStyle(
              fontFamily: "Mulish",
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      );
  }
}

// import 'dart:convert';

// import 'package:auscurator/api_service_myconcept/keys.dart';
// import 'package:auscurator/api_service_myconcept/response.dart';
// import 'package:auscurator/machine_iot/util.dart';
// import 'package:auscurator/widgets/text_widget.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';

// class APIHelper {
//   ResponseData httpErrorHandle(BuildContext context,
//       {required Response? response}) {
//     final dynamic responseData = response?.data;
//     final int statusCode = response?.statusCode ?? 500;

//     logger.w(responseData);

//     if (responseData is List && responseData.isNotEmpty) {
//       final data = responseData[0];
//       bool isError = data["is_error"] ?? true;
//       String message = data["message"] ?? 'Unknown error';

//       if (isError) {
//         showMessage1(message, duration: const Duration(seconds: 3));
//       }
//     } else if (responseData is Map) {
//       bool isError = responseData["is_error"] ?? true;
//       String message = responseData["message"] ?? 'Unknown error';

//       showMessage(context: context, isError: isError, responseMessage: message);
//     } else {
//       showMessage1('Unexpected response format',
//           duration: const Duration(seconds: 3));
//     }

//     bool isError = responseData is List
//         ? (responseData[0]["is_error"] ?? true)
//         : (responseData is Map ? responseData["is_error"] ?? true : true);

//     return ResponseData(
//       data: responseData is List && responseData.isNotEmpty
//           ? responseData[0]
//           : (responseData is Map ? responseData : {}),
//       statusCode: statusCode,
//       isError: isError,
//     );
//   }

//   Future<void> handleUnauthorized() async {
//     return storage.delete(key: StorageConstants.accessToken).then((value) {});
//   }
// }

// class StorageConstants {
//   static const String accessToken = "ACCESS_TOKEN";
//   static const String loginCreds = "login-creds";
//   static const String onboarding = "onboarding";
//   static const String languageCode = "language_code";
// }

// showMessage1(String message, {Duration duration = const Duration(seconds: 1)}) {
//   return snackbarKey.currentState
//     ?..hideCurrentSnackBar
//     ..showSnackBar(
//       SnackBar(
//         duration: duration,
//         backgroundColor: Colors.black,
//         behavior: SnackBarBehavior.floating,
//         margin: const EdgeInsets.all(12),
//         content: TextCustom(
//           message,
//           fontWeight: FontWeight.bold,
//           color: Colors.white,
//         ),
//       ),
//     );
// }

// void showMessage2(String message,
//     {Duration duration = const Duration(seconds: 1)}) {
//   final scaffoldMessenger = snackbarKey.currentState;

//   if (scaffoldMessenger != null) {
//     scaffoldMessenger
//       ..hideCurrentSnackBar() // Optionally hide the current SnackBar
//       ..showSnackBar(
//         SnackBar(
//           duration: duration,
//           backgroundColor: Colors.black,
//           behavior: SnackBarBehavior.floating,
//           margin: const EdgeInsets.all(12),
//           content: Text(
//             message,
//             style: TextStyle(
//               fontFamily: "Mulish",
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),
//           ),
//         ),
//       );
//   }
// }
