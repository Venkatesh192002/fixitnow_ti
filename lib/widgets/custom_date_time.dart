import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:ntp/ntp.dart';

class CustomDateTime {
  // static late int offset;
  static int offset =0;
  DateTime get now {
    return DateTime.now().add(Duration(milliseconds: offset));
  }

  Future<void> getOffSet() async {
    if (kIsWeb) return;
    offset = await NTP.getNtpOffset(
        localTime: DateTime.now(), lookUpAddress: "time.google.com");
  }

  List<AppLifecycleState> appLifecycleState = [];
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (kIsWeb) return;
    appLifecycleState.add(state);
    if (appLifecycleState.length == 2 &&
        appLifecycleState[appLifecycleState.length - 1] !=
            AppLifecycleState.resumed &&
        state != AppLifecycleState.resumed) return;
    getOffSet();
  }
}