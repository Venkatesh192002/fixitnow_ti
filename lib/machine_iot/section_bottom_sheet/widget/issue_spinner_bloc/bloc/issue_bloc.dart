import 'package:auscurator/api_service/api_service.dart';
import 'package:auscurator/machine_iot/section_bottom_sheet/widget/issue_spinner_bloc/event/issue_event.dart';
import 'package:auscurator/machine_iot/section_bottom_sheet/widget/issue_spinner_bloc/state/issue_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class IssueSpinnerBloc extends Bloc<IssueSpinnerEvent, IssueSpinnerState> {
  ApiService apiService = ApiService();
  IssueSpinnerBloc() : super(IssueSpinnerApiInitialState()) {
    on<IssueSpinnerApiCallEvent>((event, emit) async {
      emit(IssueSpinnerApiLoadingState());

      final response = await apiService.getListOfIssue();

      if (response.isError!) {
        emit(IssueSpinnerApiErrorState(
            errorMessage: response.message.toString()));
      }

      if (response.isError == false) {
        List<DropdownMenuEntry> listOfIssue = [];
        // for (final item in response.issueLists!) {
        //   listOfIssue.add(
        //     DropdownMenuEntry(
        //       value: item.breakdownCategoryId,
        //       label: item.breakdownCategoryName.toString(),
        //     ),
        //   );
        // }
        emit(IssueSpinnerApiLoadedState(listOfIssue: listOfIssue));
      }
    });
  }
}
