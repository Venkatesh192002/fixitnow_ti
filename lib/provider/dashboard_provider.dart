import 'package:auscurator/model/BreakdownTicketCountsModel.dart';
import 'package:auscurator/model/CategoryBasedModel.dart';
import 'package:auscurator/model/DepartmentListsModel.dart';
import 'package:auscurator/model/OpenCompletedModel.dart';
import 'package:flutter/widgets.dart';

class DashboardProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  BreakdownTicketCountsModel? _breakdownTicketCountData;
  BreakdownTicketCountsModel? get breakdownTicketCountData => _breakdownTicketCountData;
  set breakdownTicketCountData(BreakdownTicketCountsModel? val) {
    _breakdownTicketCountData = val;
    notifyListeners();
  }
  OpenCompletedModel? _openCompleteData;
  OpenCompletedModel? get openCompleteData => _openCompleteData;
  set openCompleteData(OpenCompletedModel? val) {
    _openCompleteData = val;
    notifyListeners();
  }
  CategoryBasedModel? _categoryBasedData;
  CategoryBasedModel? get categoryBasedData => _categoryBasedData;
  set categoryBasedData(CategoryBasedModel? val) {
    _categoryBasedData = val;
    notifyListeners();
  }
  DepartmentListsModel? _departmentListData;
  DepartmentListsModel? get departmentListData => _departmentListData;
  set departmentListData(DepartmentListsModel? val) {
    _departmentListData = val;
    notifyListeners();
  }

  Map<String,dynamic> _userDetails = {};
  Map<String,dynamic> get userDetails => _userDetails;
  set userDetails(Map<String,dynamic> val) {
    _userDetails = val;
    notifyListeners();
  }
}
