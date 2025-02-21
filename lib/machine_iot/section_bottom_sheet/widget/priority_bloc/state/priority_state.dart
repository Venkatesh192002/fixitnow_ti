import 'package:auscurator/machine_iot/section_bottom_sheet/ui/model_bottom_sheet_widget.dart';

class PriorityState {}

class OnSelectedState extends PriorityState {
  Set<PriorityStatus> priorityStatus;
  OnSelectedState({required this.priorityStatus});
}
