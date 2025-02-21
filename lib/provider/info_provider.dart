// ignore_for_file: empty_catches

import 'package:flutter/material.dart';

enum RequestMethod { post, get, delete, put, refresh }

class InfoProvider extends ChangeNotifier {
  bool _isHadInternet = true;
  bool get isHadInternet => _isHadInternet;
  set isHadInternet(bool val) {
    _isHadInternet = val;
    notifyListeners();
  }

  bool _isCheckingInternet = false;
  bool get isCheckingInternet => _isCheckingInternet;
  set isCheckingInternet(bool val) {
    _isCheckingInternet = val;
    notifyListeners();
  }
}
