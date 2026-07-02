import 'package:flutter_test/flutter_test.dart';
import 'package:garuda_user_app/core/error/failures.dart';
import 'package:garuda_user_app/core/utils/result.dart';
import 'package:garuda_user_app/features/auth/domain/entities/login_credentials.dart';
import 'package:garuda_user_app/features/auth/domain/entities/signup_credentials.dart';
import 'package:garuda_user_app/features/auth/domain/entities/user_entity.dart';
import 'package:garuda_user_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:garuda_user_app/features/auth/domain/services/auth_session_controller.dart';
import 'package:garuda_user_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:garuda_user_app/features/auth/presentation/bloc/auth_state.dart';

void main() {
  group('AuthBloc', () {
    late AuthSessionController sessionController;
    late _FakeAuthRepository repository;

    setUp(() {
      sessionController = AuthSessionController();
      repository = _FakeAuthRepository();
    });

    tearDown(() async {
      sessionController.dispose();
    });

    test('emits unauthenticated when session expires', () async {
      final bloc = AuthBloc(
        authRepository: repository,
        sessionController: sessionController,
      );

      final states = <AuthState>[];
      final subscription = bloc.stream.listen(states.add);

      bloc.emit(const AuthState(status: AuthStatus.authenticated));
      sessionController.notifySessionExpired();
      await Future<void>.delayed(Duration.zero);

      expect(
        states,
        contains(const AuthState(status: AuthStatus.unauthenticated)),
      );

      await subscription.cancel();
      await bloc.close();
    });
  });
}

class _FakeAuthRepository implements AuthRepository {
  @override
  Future<void> clearSession() async {}

  @override
  Future<Result<void>> deleteAccount() => throw UnimplementedError();

  @override
  Future<Result<String>> forgotPassword(String email) =>
      throw UnimplementedError();

  @override
  Future<String?> getAccessToken() async => null;

  @override
  Future<UserEntity?> getUser() async => null;

  @override
  Future<Result<UserEntity>> login(LoginCredentials credentials) =>
      throw UnimplementedError();

  @override
  Future<Result<void>> logout() async => const Success(null);

  @override
  Future<Result<String>> refreshToken() async =>
      const Error(ServerFailure(message: 'failed'));

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
