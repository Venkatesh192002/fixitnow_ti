import 'package:auscurator/machine_iot/model/save_ticket_model.dart';
import 'package:flutter/widgets.dart';

class TicketProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  List? _listEquipmentData;
  List? get listEquipmentData => _listEquipmentData;
  set listEquipmentData(List? val) {
    _listEquipmentData = val;
    notifyListeners();
  }
  SaveTicketModel? _saveTicketData;
  SaveTicketModel? get saveTicketData => _saveTicketData;
  set saveTicketData(SaveTicketModel? val) {
    _saveTicketData = val;
    notifyListeners();
  }
}
