class SaveTicketModel {
  bool? isError;
  String? message;
  int? ticketID;

  SaveTicketModel({this.isError, this.message, this.ticketID});

  SaveTicketModel.fromJson(Map<String, dynamic> json) {
    isError = json['is_error'];
    message = json['message'];
    ticketID = json['ticket_id'];
  }

  SaveTicketModel.fromError(
      {required bool isErrorThrown, required String errorMessage}) {
    isError = isErrorThrown;
    message = errorMessage;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['is_error'] = isError;
    data['message'] = message;
    data['ticket_id'] = ticketID;
    return data;
  }
}
