import 'dart:io';

import 'package:auscurator/provider/all_provider.dart';

class InfoRepository {
  Future<bool> checkInternetConnection({bool isManualCheck = false}) async {
    if (isManualCheck) infoProvider.isCheckingInternet = true;
    try {
      final result = await InternetAddress.lookup('example.com');
      bool val = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
      infoProvider.isHadInternet = true;
      if (isManualCheck) {
        Future.delayed(const Duration(seconds: 1))
            .then((value) => infoProvider.isCheckingInternet = false);
      }
      return val;
    } on SocketException catch (_) {
      infoProvider.isHadInternet = false;
      if (isManualCheck) {
        Future.delayed(const Duration(seconds: 1))
            .then((value) => infoProvider.isCheckingInternet = false);
      }
      return false;
    }
  }
}
