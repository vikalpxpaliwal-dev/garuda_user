import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:garuda_user_app/core/error/failures.dart';
import 'package:garuda_user_app/core/network/interceptors/auth_interceptor.dart';
import 'package:garuda_user_app/core/utils/result.dart';
import 'package:garuda_user_app/features/auth/domain/entities/login_credentials.dart';
import 'package:garuda_user_app/features/auth/domain/entities/signup_credentials.dart';
import 'package:garuda_user_app/features/auth/domain/entities/user_entity.dart';
import 'package:garuda_user_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:garuda_user_app/features/auth/domain/services/auth_session_controller.dart';

void main() {
  group('AuthInterceptor', () {
    test('clears session and notifies when token refresh fails on 401', () async {
      final repository = _FakeAuthRepository();
      final sessionController = AuthSessionController();
      var sessionExpiredNotified = false;

      sessionController.onSessionExpired.listen((_) {
        sessionExpiredNotified = true;
      });

      final interceptor = AuthInterceptor(
        authRepositoryProvider: () => repository,
        sessionController: sessionController,
        dioProvider: () => throw StateError('Dio should not be used'),
      );

      final handler = _RecordingErrorInterceptorHandler();
      final requestOptions = RequestOptions(path: '/buyer/wishlist');
      final error = DioException(
        requestOptions: requestOptions,
        response: Response(
          requestOptions: requestOptions,
          statusCode: 401,
        ),
        type: DioExceptionType.badResponse,
      );

      await interceptor.onError(error, handler);
      await Future<void>.delayed(Duration.zero);

      expect(repository.refreshTokenCalled, isTrue);
      expect(repository.clearSessionCalled, isTrue);
      expect(sessionExpiredNotified, isTrue);
      expect(handler.nextCalled, isTrue);
      expect(handler.nextError, same(error));

      sessionController.dispose();
    });
  });
}

class _RecordingErrorInterceptorHandler extends Fake
    implements ErrorInterceptorHandler {
  bool nextCalled = false;
  DioException? nextError;

  @override
  void next(DioException err) {
    nextCalled = true;
    nextError = err;
  }
}

class _FakeAuthRepository implements AuthRepository {
  bool refreshTokenCalled = false;
  bool clearSessionCalled = false;
  Result<String> refreshResult = const Error(
    ServerFailure(message: 'Refresh failed'),
  );

  @override
  Future<Result<String>> refreshToken() async {
    refreshTokenCalled = true;
    return refreshResult;
  }

  @override
  Future<void> clearSession() async {
    clearSessionCalled = true;
  }

  @override
  Future<Result<void>> deleteAccount() => throw UnimplementedError();

  @override
  Future<Result<String>> forgotPassword(String email) =>
      throw UnimplementedError();

  @override
  Future<String?> getAccessToken() async => 'token';

  @override
  Future<UserEntity?> getUser() => throw UnimplementedError();

  @override
  Future<Result<UserEntity>> login(LoginCredentials credentials) =>
      throw UnimplementedError();

  @override
  Future<Result<void>> logout() => throw UnimplementedError();

  @override
  Future<Result<UserEntity>> signup(SignupCredentials credentials) =>
      throw UnimplementedError();

  @override
  Future<Result<UserEntity>> updateProfile({
    required String name,
    required String phone,
    String? photoPath,
  }) =>
      throw UnimplementedError();

  @override
  Future<Result<String>> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) =>
      throw UnimplementedError();

  @override
  Future<Result<String>> verifyOtp({
    required String email,
    required String otp,
  }) =>
      throw UnimplementedError();
}
