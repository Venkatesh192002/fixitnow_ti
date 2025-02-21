class SpareData {
  final double totalCost;
  final int spareId;
  final bool isChecked;
  final String consumedQty;
  final int onHandStock;

  SpareData({
    required this.totalCost,
    required this.spareId,
    required this.isChecked,
    required this.consumedQty,
    required this.onHandStock,
  });

  Map<String, dynamic> toJson() {
    return {
      'total_cost': totalCost,
      'spare_id': spareId,
      'is_checked': isChecked.toString(),
      'consumed_qty': consumedQty,
      'on_hand_stock': onHandStock,
    };
  }
}
