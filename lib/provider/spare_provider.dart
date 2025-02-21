import 'package:auscurator/model/SpareEditListModel.dart';
import 'package:auscurator/model/SpareListsModel.dart';
import 'package:flutter/material.dart';

class SpareProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  SpareEditListsModel? _ticketData;
  SpareEditListsModel? get ticketData => _ticketData;
  set ticketData(SpareEditListsModel? val) {
    _ticketData = val;
    notifyListeners();
  }

  SpareListsModel? _spareListData;
  SpareListsModel? get spareListData => _spareListData;
  set spareListData(SpareListsModel? val) {
    _spareListData = val;
    notifyListeners();
  }
}
