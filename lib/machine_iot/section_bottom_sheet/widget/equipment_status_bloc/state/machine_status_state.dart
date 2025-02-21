import 'package:flutter/material.dart';

class MachineStatusState {

}

class MachienStatusInitialState extends MachineStatusState {
  
}

class MachienStatusLoadingState extends MachineStatusState {

}

class MachienStatusLoadedState extends MachineStatusState {
    List<DropdownMenuEntry> listOfBreakdown;
    MachienStatusLoadedState({required this.listOfBreakdown});
}

class MachineStatusErrorState extends MachineStatusState {
    String errorMessage;
    MachineStatusErrorState({required this.errorMessage});
}