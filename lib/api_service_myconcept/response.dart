class ResponseData {
  /// API's response status code
  int statusCode;

  bool isError;

  /// Api's response
  Map<String, dynamic> data;

  /// ResponseData is a data from the api response
  ResponseData({required this.statusCode, required this.data,required this.isError});
}
