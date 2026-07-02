import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ApiLoggerInterceptor extends Interceptor {
  static const _sensitivePathFragments = <String>[
    '/buyer/login',
    '/buyer/signup',
    '/buyer/refresh',
    '/buyer/logout',
    '/buyer/forgot-password',
    '/buyer/reset-password',
    '/buyer/verify-otp',
  ];

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      log(
        'REQUEST [${options.method}] ${_redactedUri(options.uri)}',
        name: 'Dio',
      );
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
        'RESPONSE [${response.statusCode}] ${_redactedUri(response.requestOptions.uri)}',
        name: 'Dio',
      );
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      final statusCode = err.response?.statusCode;
      log(
        'ERROR [$statusCode] ${_redactedUri(err.requestOptions.uri)}',
        name: 'Dio',
      );
    }
    handler.next(err);
  }

  static String _redactedUri(Uri uri) {
    final path = uri.path;
    final isSensitive = _sensitivePathFragments.any(path.contains);
    if (isSensitive) {
      return '${uri.scheme}://${uri.host}$path [redacted]';
    }
    return uri.toString();
  }
}
