import 'package:auscurator/model/BreakdownTicketModel.dart';
import 'package:auscurator/model/MainCategoryModel.dart';
import 'package:auscurator/model/SubCategoryModel.dart';
import 'package:auscurator/model/TicketDetailModel.dart';
import 'package:flutter/foundation.dart';

class BreakkdownProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  TicketDetailModel? _ticketDetailData;
  TicketDetailModel? get ticketDetailData => _ticketDetailData;
  set ticketDetailData(TicketDetailModel? val) {
    _ticketDetailData = val;
    notifyListeners();
  }
  MainCategoryModel? _mainCategoryData;
  MainCategoryModel? get mainCategoryData => _mainCategoryData;
  set mainCategoryData(MainCategoryModel? val) {
    _mainCategoryData = val;
    notifyListeners();
  }
  SubCategoryModel? _subCategoryData;
  SubCategoryModel? get subCategoryData => _subCategoryData;
  set subCategoryData(SubCategoryModel? val) {
    _subCategoryData = val;
    notifyListeners();
  }
  BreakkdownTicketModel? _breakDownOverallData;
  BreakkdownTicketModel? get breakDownOverallData => _breakDownOverallData;
  set breakDownOverallData(BreakkdownTicketModel? val) {
    _breakDownOverallData = val;
    notifyListeners();
  }
  // RootCauseModel? _rootCauseData;
  // RootCauseModel? get rootCauseData => _rootCauseData;
  // set rootCauseData(RootCauseModel? val) {
    // _rootCauseData = val;
    // notifyListeners();
  // }
}