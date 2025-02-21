import 'package:auscurator/machine_iot/model/break_down_status_list_model.dart';

class BreakdownStatusState {}

class BreakdownStatusInitialState extends BreakdownStatusState {}

class BreakdownStatusLoadingState extends BreakdownStatusState {}

class BreakdownStatusLoadedState extends BreakdownStatusState {
  List<BreakdownStatusLists> listOfBreakdownStatus;
  String selectedId;
  BreakdownStatusLoadedState(
      {required this.listOfBreakdownStatus, required this.selectedId});
}

class BreakdownStatusErrorState extends BreakdownStatusState {
  String message;
  BreakdownStatusErrorState({required this.message});
}
