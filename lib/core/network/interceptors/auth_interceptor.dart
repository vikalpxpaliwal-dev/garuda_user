import 'dart:async';
import 'package:dio/dio.dart';
import 'package:garuda_user_app/core/di/service_locator.dart';
import 'package:garuda_user_app/core/utils/result.dart';
import 'package:garuda_user_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:garuda_user_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:garuda_user_app/features/auth/presentation/bloc/auth_event.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor();

  // Lazy dependencies to break circular dependencies in DI
  AuthRepository get _authRepository => sl<AuthRepository>();
  AuthBloc get _authBloc => sl<AuthBloc>();
  Dio get _dio => sl<Dio>();

  bool _isRefreshing = false;
  final _requestsQueue = <MapEntry<RequestOptions, ErrorInterceptorHandler>>[];

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final path = options.path;
    final isAuthRequest =
        path.contains('/buyer/refresh') ||
        path.contains('/buyer/login') ||
        path.contains('/buyer/signup');

    if (!isAuthRequest) {
      final token = await _authRepository.getAccessToken();
      if (token != null && token.isNotEmpty) {
        print('AccessToken: $token');
        options.headers['Authorization'] = 'Bearer $token';
      }
    }

    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final path = err.requestOptions.path;
    final isAuthRequest =
        path.contains('/buyer/refresh') ||
        path.contains('/buyer/login') ||
        path.contains('/buyer/signup');

    if (err.response?.statusCode == 401 && !isAuthRequest) {
      if (_isRefreshing) {
        // Queue the request
        _requestsQueue.add(MapEntry(err.requestOptions, handler));
        return;
      }

      _isRefreshing = true;
      final result = await _authRepository.refreshToken();

      if (result is Success<String>) {
        final newToken = result.data;
        _isRefreshing = false;

        // 1. Retry original request
        final options = err.requestOptions;
        options.headers['Authorization'] = 'Bearer $newToken';

        try {
          final response = await _dio.fetch(options);
          handler.resolve(response);

          // 2. Retry queued requests
          _retryQueuedRequests(newToken);
        } catch (e) {
          handler.next(err);
        }
      } else {
        _isRefreshing = false;
        _authBloc.add(UserLoggedOut());
        _clearQueue(err);
        handler.next(err);
      }
    } else {
      handler.next(err);
    }
  }

  void _retryQueuedRequests(String token) {
    for (final entry in _requestsQueue) {
      final options = entry.key;
      final handler = entry.value;
      options.headers['Authorization'] = 'Bearer $token';

      _dio
          .fetch(options)
          .then(
            (response) => handler.resolve(response),
            onError: (e) => handler.reject(e as DioException),
          );
    }
    _requestsQueue.clear();
  }

  void _clearQueue(DioException originalErr) {
    for (final entry in _requestsQueue) {
      entry.value.reject(originalErr);
    }
    _requestsQueue.clear();
  }
}
