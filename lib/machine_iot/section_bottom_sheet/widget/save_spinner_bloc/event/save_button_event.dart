class SaveButtonEvent {}

class SaveButtonOnClickEvent extends SaveButtonEvent {
  String assetGroupId;
  String assetId;
  String breakdownCategoryId;
  String breakdownsubCategoryId;
  String assetStatus;
  String priorityId;
  String userLoginId;
  String comment;

  SaveButtonOnClickEvent({
    required this.assetGroupId,
    required this.assetId,
    required this.breakdownCategoryId,
    required this.breakdownsubCategoryId,
    required this.assetStatus,
    required this.priorityId,
    required this.userLoginId,
    required this.comment,
  });
}
