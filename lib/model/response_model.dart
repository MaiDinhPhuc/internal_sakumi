class APIResponseModel {
  final int? statusCode;
  final String? statusMessage;
  final dynamic json;

  APIResponseModel({this.statusCode, this.statusMessage, this.json});
}