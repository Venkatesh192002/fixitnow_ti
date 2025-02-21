import 'package:auscurator/api_service/api_service.dart';
import 'package:auscurator/machine_iot/section_bottom_sheet/widget/equipment_status_bloc/event/machine_status_event.dart';
import 'package:auscurator/machine_iot/section_bottom_sheet/widget/equipment_status_bloc/state/machine_status_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MachineStatusBloc extends Bloc<MachineStatusEvent, MachineStatusState> {
  ApiService apiService = ApiService();
  MachineStatusBloc() : super(MachienStatusInitialState()) {
    on<MachineStatusApiCallEvent>((event, emit) async {
      try {
        emit(
          MachienStatusLoadingState(),
        );

        // final response = await apiService.getBreakdownStatus(
        //   plantId: '1',
        //   departmentId: '1',
        //   equipmentid: '1',
        // );

        // if (response.isError!) {
        //   emit(
        //     MachineStatusErrorState(
        //       errorMessage: response.message.toString(),
        //     ),
        //   );
        // }

        // if (response.isError! == false) {
        //   List<DropdownMenuEntry> listOfBreakDown = [];
        //   for (final item in response.breakdownStatusLists!) {
        //     listOfBreakDown.add(
        //       DropdownMenuEntry(
        //         value: item.breakdownStatusId,
        //         label: item.breakdownStatus.toString(),
        //       ),
        //     );
        //   }
        //   emit(MachienStatusLoadedState(listOfBreakdown: listOfBreakDown));
        // }
      } catch (e) {
        emit(
          MachineStatusErrorState(
            errorMessage: e.toString(),
          ),
        );
      }
    });
  }
}
