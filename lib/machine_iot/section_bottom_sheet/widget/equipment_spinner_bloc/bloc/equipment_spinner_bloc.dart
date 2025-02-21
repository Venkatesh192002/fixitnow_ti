import 'package:auscurator/api_service/api_service.dart';
import 'package:auscurator/machine_iot/section_bottom_sheet/widget/equipment_spinner_bloc/event/equipment_spinner_event.dart';
import 'package:auscurator/machine_iot/section_bottom_sheet/widget/equipment_spinner_bloc/model/AssetModel.dart';
import 'package:auscurator/machine_iot/section_bottom_sheet/widget/equipment_spinner_bloc/state/equipment_spinner_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EquipmentSpinnerBloc
    extends Bloc<EquipmentSpinnerEvent, EquipmentSpinnerState> {
  ApiService apiService = ApiService();

  List<AssetLists> listOfEquipment = [];

  EquipmentSpinnerBloc() : super(EquipmentSpinnerApiInitialState()) {
    on<EquipmentSpinnerApiCallEvent>((event, emit) async {
      emit(EquipmentSpinnerApiLoadingState());
      try {
        final data = await apiService.getListOfEquipment(assetGroupId: '');

        if (data.isError!) {
          emit(EquipmentSpinnerApiErrortate(
              isError: data.isError!, message: data.message!));
        }

        if (data.isError! == false) {
          listOfEquipment = data.assetLists!;

          List<DropdownMenuEntry> listOfMenu = [];

          for (final item in data.assetLists!) {
            listOfMenu.add(
              DropdownMenuEntry(
                value: item.assetId,
                label: item.assetName.toString(),
              ),
            );
          }

          emit(EquipmentSpinnerApiLoadedState(
              cmmsEquipmentListModel: listOfMenu));
        }
      } catch (e) {
        emit(EquipmentSpinnerApiErrortate(isError: true, message: '$e'));
      }
      print('sheet_equipment: 0');
    });

    on<EquipmentSpinnerOnItemClickEvent>((event, emit) {});
  }
}
