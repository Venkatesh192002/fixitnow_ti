import 'package:auscurator/machine_iot/section_bottom_sheet/widget/equipment_spinner_bloc/model/AssetModel.dart';
import 'package:auscurator/model/AssetGroupModel.dart';
import 'package:auscurator/model/asset_engineer_id.dart';
import 'package:auscurator/model/asset_head_engineer_model.dart';
import 'package:flutter/widgets.dart';

class AssetProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  AssetGroupModel? _assetGroupData;
  AssetGroupModel? get assetGroupData => _assetGroupData;
  set assetGroupData(AssetGroupModel? val) {
    _assetGroupData = val;
    notifyListeners();
  }
  AssetModel? _assetModelData;
  AssetModel? get assetModelData => _assetModelData;
  set assetModelData(AssetModel? val) {
    _assetModelData = val;
    notifyListeners();
  }
  AssetEngIdModel? _assetEngId;
  AssetEngIdModel? get assetEngId => _assetEngId;
  set assetEngId(AssetEngIdModel? val) {
    _assetEngId = val;
    notifyListeners();
  }
  AssetHeadIdModel? _assetHeadEngId;
  AssetHeadIdModel? get assetHeadEngId => _assetHeadEngId;
  set assetHeadEngId(AssetHeadIdModel? val) {
    _assetHeadEngId = val;
    notifyListeners();
  }
}
