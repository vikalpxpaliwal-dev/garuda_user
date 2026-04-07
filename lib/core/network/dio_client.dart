import 'package:dio/dio.dart';
import 'package:garuda_user_app/core/constants/app_constants.dart';
import 'package:garuda_user_app/core/network/interceptors/auth_interceptor.dart';
import 'package:garuda_user_app/core/network/interceptors/logging_interceptor.dart';

class DioClient {
  DioClient({
    required String baseUrl,
    required AuthInterceptor authInterceptor,
    required ApiLoggerInterceptor loggerInterceptor,
  }) : client =
           Dio(
               BaseOptions(
                 baseUrl: baseUrl,
                 connectTimeout: AppConstants.connectTimeout,
                 receiveTimeout: AppConstants.receiveTimeout,
                 sendTimeout: AppConstants.sendTimeout,
                 headers: const <String, Object>{
                   'Accept': 'application/json',
                   'Content-Type': 'application/json',
                 },
               ),
             )
             ..interceptors.addAll(<Interceptor>[
               authInterceptor,
               loggerInterceptor,
             ]);

  final Dio client;
}
