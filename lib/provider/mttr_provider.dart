import 'package:auscurator/model/MTTRListModel.dart';
import 'package:auscurator/model/MTTRUpdateListModel.dart';
import 'package:flutter/material.dart';

class MttrProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  MTTRListModel? _mttrListsData;
  MTTRListModel? get mttrListsData => _mttrListsData;
  set mttrListsData(MTTRListModel? val) {
    _mttrListsData = val;
    notifyListeners();
  }

  MTTRUpdateListModel? _mttrUpdateData;
  MTTRUpdateListModel? get mttrUpdateData => _mttrUpdateData;
  set mttrUpdateData(MTTRUpdateListModel? val) {
    _mttrUpdateData = val;
    notifyListeners();
  }

  int total = 0;

  void updateValue(
      int index, String value, List<TextEditingController> controllers) {
    int totalSeconds = 0;
    for (var controller in controllers) {
      totalSeconds += _convertToSeconds(controller.text);
    }
    total = totalSeconds;
    notifyListeners();
  }

  int _convertToSeconds(String time) {
    final parts = time.split(':');
    if (parts.length != 3) return 0;
    final hours = int.tryParse(parts[0]) ?? 0;
    final minutes = int.tryParse(parts[1]) ?? 0;
    final seconds = int.tryParse(parts[2]) ?? 0;
    return (hours * 3600) + (minutes * 60) + seconds;
  }
}
