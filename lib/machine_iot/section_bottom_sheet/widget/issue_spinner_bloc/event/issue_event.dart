class IssueSpinnerEvent {

}

class IssueSpinnerApiCallEvent extends IssueSpinnerEvent {
  String selectedEquipmentId;
  IssueSpinnerApiCallEvent({required this.selectedEquipmentId});
}