
class SpareEditListsModel {
  bool isError; // Changed to non-nullable
  String message; // Changed to non-nullable
  List<TicketSpareData> ticketSpareData; // Changed to non-nullable

  SpareEditListsModel({
    required this.isError,
    required this.message,
    required this.ticketSpareData,
  });

  SpareEditListsModel.fromJson(Map<String, dynamic> json)
      : isError = json['is_error'] ?? false, // Default to false if null
        message = json['message'] ??
            'No message available', // Provide a default message
        ticketSpareData = (json['ticket_spare_data'] as List?)
                ?.map((v) => TicketSpareData.fromJson(v))
                .toList() ??
            [];

  SpareEditListsModel.fromError({
    required bool isErrorThrown,
    required String errorMessage,
  })  : isError = isErrorThrown,
        message = errorMessage,
        ticketSpareData = []; // Default to an empty list on error

  Map<String, dynamic> toJson() {
    return {
      'is_error': isError,
      'message': message,
      'ticket_spare_data': ticketSpareData.map((v) => v.toJson()).toList(),
    };
  }
}

class TicketSpareData {
  int spareId; // Changed to non-nullable
  String spareCode; // Changed to non-nullable
  String spareName; // Changed to non-nullable
  String spareLocation; // Changed to non-nullable
  String spareMake; // Changed to non-nullable
  int spareMinQty; // Changed to non-nullable
  int spareStock; // Changed to non-nullable
  int spareUnitPrice; // Changed to non-nullable
  String isChecked; // Changed to non-nullable
  int consumedQty; // Changed to non-nullable
  double totalCost; // Changed to non-nullable

  TicketSpareData({
    required this.spareId,
    required this.spareCode,
    required this.spareName,
    required this.spareLocation,
    required this.spareMake,
    required this.spareMinQty,
    required this.spareStock,
    required this.spareUnitPrice,
    required this.isChecked,
    required this.consumedQty,
    required this.totalCost,
  });

  TicketSpareData.fromJson(Map<String, dynamic> json)
      : spareId = json['spare_id'] ?? 0, // Provide a default value
        spareCode = json['spare_code'] ?? '', // Provide a default value
        spareName = json['spare_name'] ?? '', // Provide a default value
        spareLocation = json['spare_location'] ?? 0, // Provide a default value
        spareMake = json['spare_make'] ?? '', // Provide a default value
        spareMinQty = json['spare_min_qty'] ?? 0, // Provide a default value
        spareStock = json['spare_stock'] ?? 0, // Provide a default value
        spareUnitPrice =
            json['spare_unit_price'] ?? 0, // Provide a default value
        isChecked = json['is_checked'] ?? 'false', // Provide a default value
        consumedQty = json['consumed_qty'] ?? 0, // Provide a default value
        totalCost = json['total_cost'] ?? 0; // Provide a default value

  Map<String, dynamic> toJson() {
    return {
      'spare_id': spareId,
      'spare_code': spareCode,
      'spare_name': spareName,
      'spare_location': spareLocation,
      'spare_make': spareMake,
      'spare_min_qty': spareMinQty,
      'spare_stock': spareStock,
      'spare_unit_price': spareUnitPrice,
      'is_checked': isChecked,
      'consumed_qty': consumedQty,
      'total_cost': totalCost,
    };
  }
}
