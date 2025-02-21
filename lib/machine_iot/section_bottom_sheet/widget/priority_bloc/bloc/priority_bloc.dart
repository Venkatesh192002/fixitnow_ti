import 'package:auscurator/machine_iot/section_bottom_sheet/ui/model_bottom_sheet_widget.dart';
import 'package:auscurator/machine_iot/section_bottom_sheet/widget/priority_bloc/event/priority_event.dart';
import 'package:auscurator/machine_iot/section_bottom_sheet/widget/priority_bloc/state/priority_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PriorityBloc extends Bloc<PriorityEvent, PriorityState> {
  PriorityBloc()
      : super(OnSelectedState(priorityStatus: {PriorityStatus.high})) {
    on<OnItemClickPriority>((event, emit) {
      print('priority_event');
      emit(OnSelectedState(priorityStatus: event.priorityStatus));
    });
  }
}
