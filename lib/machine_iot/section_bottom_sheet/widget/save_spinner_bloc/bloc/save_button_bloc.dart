import 'package:auscurator/api_service/api_service.dart';
import 'package:auscurator/machine_iot/section_bottom_sheet/widget/save_spinner_bloc/event/save_button_event.dart';
import 'package:auscurator/machine_iot/section_bottom_sheet/widget/save_spinner_bloc/state/save_button_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SaveButtonBloc extends Bloc<SaveButtonEvent, SaveButtonState> {
  ApiService apiService = ApiService();
  SaveButtonBloc() : super(SavebuttonInitialState()) {
    on<SaveButtonOnClickEvent>(
      (event, emit) async {
        emit(SaveButtonLoadingState());
        try {
          final response = await apiService.saveTicket(
              assetGroupId: event.assetGroupId,
              assetId: event.assetId,
              breakdownCategoryId: event.breakdownCategoryId,
              assetStatus: event.assetStatus,
              priorityId: event.priorityId,
              userLoginId: event.userLoginId,
              comment: event.comment);
          if (response.isError!) {
            emit(SaveButtonSuccessState(message: response.message.toString()));
          }

          if (response.isError == false) {
            emit(SaveButtonSuccessState(message: response.message.toString()));
          }
        } catch (e) {
          emit(SaveButtonErrorState(errorMessage: e.toString()));
        }
      },
    );
  }
}
