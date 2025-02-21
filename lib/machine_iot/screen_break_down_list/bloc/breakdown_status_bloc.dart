import 'package:auscurator/api_service/api_service.dart';
import 'package:auscurator/machine_iot/model/break_down_status_list_model.dart';
import 'package:auscurator/machine_iot/screen_break_down_list/event/breakdown_status_event.dart';
import 'package:auscurator/machine_iot/screen_break_down_list/state/breakdown_status_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BreakDownStatusBloc
    extends Bloc<BreakdownStatusEvent, BreakdownStatusState> {
  ApiService apiService = ApiService();
  List<BreakdownStatusLists> listOfStatus = [];
  BreakDownStatusBloc() : super(BreakdownStatusInitialState()) {
    on<BreakdownStatusApiCallEvent>((event, emit) async {
      emit(BreakdownStatusLoadingState());

      try {
        final result = await apiService.getBreakDownStatusList(
            breakdown_status: '',
            from_date: '',
            period: '',
            to_date: '',
            user_login_id: '');

        if (result.isError!) {
          emit(BreakdownStatusErrorState(message: result.message.toString()));
        }

        if (result.isError! == false) {
          listOfStatus = [
            BreakdownStatusLists(breakdownStatus: 'Open'),
            BreakdownStatusLists(breakdownStatus: 'Assign'),
            BreakdownStatusLists(breakdownStatus: 'Accept'),
            BreakdownStatusLists(breakdownStatus: 'On Progress'),
            BreakdownStatusLists(breakdownStatus: 'Pending'),
            BreakdownStatusLists(breakdownStatus: 'Hold'),
            BreakdownStatusLists(breakdownStatus: 'Acknowledge'),
            BreakdownStatusLists(breakdownStatus: 'Closed'),
          ]; //result.breakdownStatusLists!;
          emit(BreakdownStatusLoadedState(
              listOfBreakdownStatus: listOfStatus, selectedId: 'open'));
        }
      } catch (e) {
        emit(BreakdownStatusErrorState(message: e.toString()));
      }
    });
    on<BreakStatusOnItemClick>((event, emit) {
      emit(BreakdownStatusLoadedState(
          listOfBreakdownStatus: listOfStatus,
          selectedId: event.selectedStatusId));
    });
  }
}
