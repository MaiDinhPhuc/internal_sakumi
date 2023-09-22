

import 'package:dio/dio.dart';
import 'package:flutter/Material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:internal_sakumi/configs/app_configs.dart';
import 'package:internal_sakumi/model/response_model.dart';

class APIProvider {
  final Dio _dio;

  APIProvider._internal()
      : _dio = Dio(BaseOptions(
    contentType: Headers.formUrlEncodedContentType,
    baseUrl: AppConfigs.endPoint,
    connectTimeout: const Duration(seconds: 30000),
    receiveTimeout: const Duration(seconds: 30000),
  ));
  static final APIProvider _instance = APIProvider._internal();

  static APIProvider get instance => _instance;

  Future<APIResponseModel> get(String url,
      {Map<String, dynamic>? data,
        String? authorizationToken,
        bool isList = false}) async {
    debugPrint("GET ------------------------> $url");
    debugPrint("$data");

    DateTime time = DateTime.now();
    int durationMilis = 0;
    if (authorizationToken != null) {
      _dio.options.headers["Authorization"] = "Bearer $authorizationToken";
    }
    try {

      Response<dynamic> response = await _dio.get(url, queryParameters: data);

      durationMilis = DateTime.now().difference(time).inMilliseconds;

      if (response.statusCode != 200) {
        showError(
            response.statusMessage ?? 'errorCode : ${response.statusCode}');
      }
      return APIResponseModel(
          statusCode: response.statusCode,
          statusMessage: response.statusMessage,
          json: response.data);
    } on DioException catch (e) {
      showError(e.toString());
      // showError(e.response?.data.toString() ??
      //     'errorCode : ${e.response?.statusCode}');
      debugPrint("==============> get url $url");
      debugPrint("==============> get response ${e.response}");
      debugPrint("==============> get type ${e.type}");
      debugPrint("==============> get message ${e.message}");
      debugPrint("==============> get error ${e.error}");
      debugPrint("==============> get stackTrace ${e.stackTrace}");

      durationMilis = DateTime.now().difference(time).inMilliseconds;

      if (e.response != null) {
        showError(e.response!.data.toString() ??
            'errorCode : ${e.response!.statusCode}');
        return APIResponseModel(
            statusCode: e.response!.statusCode,
            statusMessage: e.response!.statusMessage,
            json: e.response!.data);
      }
      return APIResponseModel();
    }
  }

  showError(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}