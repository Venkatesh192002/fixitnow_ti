import 'package:auscurator/api_service_myconcept/keys.dart';
import 'package:auscurator/api_service_myconcept/response.dart';
import 'package:auscurator/machine_iot/util.dart';
import 'package:flutter/material.dart';

// extension ResponseExtension on ResponseData {
//   bool get hasError {
//     if (!data["is_error"]) {
//       return false;
//     }
//     if (data["is_error"]) return true;
//     String errMsg = data['message'] ?? '';
//     if (errMsg.isNotEmpty) showMessage1(errMsg);
//     return true;
//   }
// }

extension ResponseExtension on ResponseData {
  bool hasError(BuildContext? context) {
    if (data["is_error"] == true) {
      String errMsg = data['message'] ?? '';
      logger.e("Error detected: $errMsg"); // Logging error
      if (errMsg.isNotEmpty && context != null) {
        showMessage(
          context: context,
          isError: true,
          responseMessage: errMsg,
        ); // Display message
      }
      return true;
    }
    return false;
  }
}
