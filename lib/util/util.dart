import 'package:auscurator/util/shared_util.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class Util {
  String message;

  Util(this.message);

  static showToastMessage(
      double height, BuildContext context, String message, bool isError) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor:
            isError ? Colors.red : const Color.fromARGB(255, 4, 85, 7),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(bottom: height, left: 10, right: 10),
        content: Text(message),
        duration: const Duration(seconds: 1),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        action: SnackBarAction(
          //backgroundColor: ,
          textColor: Color.fromRGBO(30, 152, 165, 1),
          label: "Ok",
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  static String? getColorCode({
    required dynamic apiValue1,
    required dynamic apiValue2,
    required dynamic apiValue3,
    required dynamic currentValue,
    required dynamic color1,
    required dynamic color2,
    required dynamic color3,
  }) {
    if (apiValue1 == null || apiValue2 == null || apiValue3 == null) {
      return null;
    }

    if (color1 == null || color2 == null || color3 == null) {
      return null;
    }

    if (currentValue <= apiValue1) {
      return color1;
    }

    if (currentValue <= apiValue2) {
      return color2;
    }

    if (currentValue <= apiValue3) {
      return color3;
    }

    return '#000000';
  }

  static bool isTokenExpired() {
    String jwtToken = SharedUtil().getDecryptedJWTToken;

    bool isExpired = JwtDecoder.isExpired(jwtToken);

    return isExpired;
  }
}
