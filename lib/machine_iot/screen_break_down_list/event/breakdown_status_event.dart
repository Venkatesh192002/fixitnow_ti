class BreakdownStatusEvent {

}

class BreakdownStatusApiCallEvent extends BreakdownStatusEvent {

}

class BreakStatusOnItemClick extends BreakdownStatusEvent {
  String selectedStatusId;
  BreakStatusOnItemClick({required this.selectedStatusId});
}