import 'package:auscurator/model/BreakdownTicketModel.dart';

class BreakDownListState {}

class BreakDownListInitialState extends BreakDownListState {}

class BreakDownListApiLoadingState extends BreakDownListState {}

class BreakDownListEmptyDataState extends BreakDownListState {}

class BreakDownListLoadedState extends BreakDownListState {
  List<BreakdownDetailList> listOfBreakdown;
  BreakDownListLoadedState({required this.listOfBreakdown});
}

class BreakDownListErrorState extends BreakDownListState {
  String errorMessage;
  BreakDownListErrorState({required this.errorMessage});
}
