import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      print('--- API Request ---');
      print('URL: ${options.baseUrl}${options.path}');
      print('Method: ${options.method}');
      print('Headers: ${options.headers}');
      print('Query Parameters: ${options.queryParameters}');
      print('Body: ${options.data}');
      print('-------------------');
    }
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      print('--- API Response ---');
      print('Status Code: ${response.statusCode}');
      print('URL: ${response.requestOptions.baseUrl}${response.requestOptions.path}');
      print('Data: ${response.data}');
      print('--------------------');
    }
    return super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      print('--- API Error ---');
      print('URL: ${err.requestOptions.baseUrl}${err.requestOptions.path}');
      print('Status Code: ${err.response?.statusCode}');
      print('Error Message: ${err.message}');
      print('Error Data: ${err.response?.data}');
      print('-----------------');
    }
    return super.onError(err, handler);
  }
}
