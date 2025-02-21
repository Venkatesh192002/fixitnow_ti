class SaveTicketStatusModel {
  bool? isError;
  String? message;

  SaveTicketStatusModel({this.isError, this.message});

  SaveTicketStatusModel.fromJson(Map<String, dynamic> json) {
    isError = json['is_error'];
    message = json['message'];
  }

  SaveTicketStatusModel.fromError(
      {required bool isErrorThrown, required String errorMessage}) {
    isError = isErrorThrown;
    message = errorMessage;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['is_error'] = isError;
    data['message'] = message;

    return data;
  }
}
