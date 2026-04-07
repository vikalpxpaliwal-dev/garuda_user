import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ApiLoggerInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      log('REQUEST [${options.method}] ${options.uri}', name: 'Dio');
    }
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    if (kDebugMode) {
      log(
        'RESPONSE [${response.statusCode}] ${response.requestOptions.uri}',
        name: 'Dio',
      );
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      log(
        'ERROR [${err.response?.statusCode}] ${err.requestOptions.uri} ${err.message}',
        name: 'Dio',
      );
    }
    handler.next(err);
  }
}
