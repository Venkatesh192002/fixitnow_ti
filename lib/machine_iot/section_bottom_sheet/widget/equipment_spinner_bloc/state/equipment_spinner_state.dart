import 'package:flutter/material.dart';

class EquipmentSpinnerState {}

class EquipmentSpinnerApiInitialState extends EquipmentSpinnerState {}

class EquipmentSpinnerApiLoadingState extends EquipmentSpinnerState {}

class EquipmentSpinnerApiLoadedState extends EquipmentSpinnerState {
  List<DropdownMenuEntry> cmmsEquipmentListModel;
  EquipmentSpinnerApiLoadedState({required this.cmmsEquipmentListModel});
}

class EquipmentSpinnerApiErrortate extends EquipmentSpinnerState {
  bool isError;
  String message;
  EquipmentSpinnerApiErrortate({required this.isError, required this.message});
}
