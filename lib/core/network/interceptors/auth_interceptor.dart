import 'package:dio/dio.dart';
import 'package:garuda_user_app/core/utils/result.dart';
import 'package:garuda_user_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:garuda_user_app/features/auth/domain/services/auth_session_controller.dart';

typedef DioProvider = Dio Function();
typedef AuthRepositoryProvider = AuthRepository Function();

class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    required AuthRepositoryProvider authRepositoryProvider,
    required AuthSessionController sessionController,
    required DioProvider dioProvider,
  })  : _authRepositoryProvider = authRepositoryProvider,
        _sessionController = sessionController,
        _dioProvider = dioProvider;

  final AuthRepositoryProvider _authRepositoryProvider;
  final AuthSessionController _sessionController;
  final DioProvider _dioProvider;

  AuthRepository get _authRepository => _authRepositoryProvider();

  bool _isRefreshing = false;
  final _requestsQueue = <MapEntry<RequestOptions, ErrorInterceptorHandler>>[];

  Dio get _dio => _dioProvider();

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final path = options.path;
    final isAuthRequest = _isAuthPath(path);

    if (!isAuthRequest) {
      final token = await _authRepository.getAccessToken();
      if (token != null && token.isNotEmpty) {
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
    final isAuthRequest = _isAuthPath(path);

    if (err.response?.statusCode == 401 && !isAuthRequest) {
      if (_isRefreshing) {
        _requestsQueue.add(MapEntry(err.requestOptions, handler));
        return;
      }

      _isRefreshing = true;
      final result = await _authRepository.refreshToken();

      if (result is Success<String>) {
        final newToken = result.data;
        _isRefreshing = false;

        final options = err.requestOptions;
        options.headers['Authorization'] = 'Bearer $newToken';

        try {
          final response = await _dio.fetch(options);
          handler.resolve(response);
          _retryQueuedRequests(newToken);
        } catch (e) {
          handler.next(err);
        }
      } else {
        _isRefreshing = false;
        await _authRepository.clearSession();
        _sessionController.notifySessionExpired();
        _clearQueue(err);
        handler.next(err);
      }
    } else {
      handler.next(err);
    }
  }

  bool _isAuthPath(String path) {
    return path.contains('/buyer/refresh') ||
        path.contains('/buyer/login') ||
        path.contains('/buyer/signup');
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
