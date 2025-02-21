class EquipmentSpinnerEvent {}

class EquipmentSpinnerApiCallEvent extends EquipmentSpinnerEvent {
  String asset_id;
  String company_id;
  String bu_id;
  String plant_id;
  String department_id;
  String location_id;
  String asset_group_id;
  String status;

  EquipmentSpinnerApiCallEvent(
      {required this.asset_id,
      required this.company_id,
      required this.bu_id,
      required this.plant_id,
      required this.department_id,
      required this.location_id,
      required this.asset_group_id,
      required this.status});
}

class EquipmentSpinnerOnItemClickEvent extends EquipmentSpinnerEvent {
  String equipmentId;
  String equipmentName;

  EquipmentSpinnerOnItemClickEvent(
      {required this.equipmentId, required this.equipmentName});
}
