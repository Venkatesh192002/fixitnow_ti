import 'package:auscurator/model/work_log_model.dart';
import 'package:auscurator/model/worklogdetail_model.dart';
import 'package:flutter/material.dart';

class WorkLogProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  WorklogModel? _workLogData;
  WorklogModel? get workLogData => _workLogData;
  set workLogData(WorklogModel? val) {
    _workLogData = val;
    notifyListeners();
  }
  WorklogDetailModel? _workLogDetailData;
  WorklogDetailModel? get workLogDetailData => _workLogDetailData;
  set workLogDetailData(WorklogDetailModel? val) {
    _workLogDetailData = val;
    notifyListeners();
  }
}