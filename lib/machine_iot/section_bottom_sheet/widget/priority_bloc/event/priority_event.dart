import 'package:auscurator/machine_iot/section_bottom_sheet/ui/model_bottom_sheet_widget.dart';

class PriorityEvent {}

class OnItemClickPriority extends PriorityEvent {
  Set<PriorityStatus> priorityStatus;
  OnItemClickPriority({required this.priorityStatus});
}
