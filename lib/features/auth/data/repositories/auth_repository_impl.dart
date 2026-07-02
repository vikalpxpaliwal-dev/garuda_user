import 'package:garuda_user_app/core/data/repository_executor.dart';
import 'package:garuda_user_app/core/error/failures.dart';
import 'package:garuda_user_app/core/utils/result.dart';
import 'package:garuda_user_app/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:garuda_user_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:garuda_user_app/features/auth/data/mappers/auth_request_mapper.dart';
import 'package:garuda_user_app/features/auth/domain/entities/login_credentials.dart';
import 'package:garuda_user_app/features/auth/domain/entities/signup_credentials.dart';
import 'package:garuda_user_app/features/auth/domain/entities/user_entity.dart';
import 'package:garuda_user_app/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required AuthLocalDataSource localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;

  @override
  Future<Result<UserEntity>> signup(SignupCredentials credentials) {
    return RepositoryExecutor.runSafely(() async {
      final response = await _remoteDataSource.signup(
        AuthRequestMapper.toSignupRequestModel(credentials),
      );
      return response.data;
    });
  }

  @override
  Future<Result<UserEntity>> login(LoginCredentials credentials) {
    return RepositoryExecutor.runSafely(() async {
      final response = await _remoteDataSource.login(
        AuthRequestMapper.toLoginRequestModel(credentials),
      );

      await _localDataSource.saveTokens(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
      );
      await _localDataSource.saveUser(response.data);

      return response.data;
    });
  }

  @override
  Future<Result<String>> refreshToken() async {
    final refreshToken = await _localDataSource.getRefreshToken();
    if (refreshToken == null) {
      return Error(const ServerFailure(message: 'No refresh token available'));
    }

    return RepositoryExecutor.runSafely(() async {
      final newAccessToken = await _remoteDataSource.refresh(refreshToken);
      await _localDataSource.saveTokens(
        accessToken: newAccessToken,
        refreshToken: refreshToken,
      );
      return newAccessToken;
    }, policy: RepositoryErrorPolicy.serverOnly);
  }

  @override
  Future<void> clearSession() async {
    await _localDataSource.clear();
  }

  @override
  Future<Result<void>> logout() async {
    try {
      final refreshToken = await _localDataSource.getRefreshToken();
      if (refreshToken != null) {
        await _remoteDataSource.logout(refreshToken);
      }
      await _localDataSource.clear();
      return const Success(null);
    } catch (_) {
      await _localDataSource.clear();
      return const Success(null);
    }
  }

  @override
  Future<String?> getAccessToken() async {
    return _localDataSource.getAccessToken();
  }

  @override
  Future<Result<UserEntity>> updateProfile({
    required String name,
    required String phone,
    String? photoPath,
  }) {
    return RepositoryExecutor.runSafely(() async {
      final response = await _remoteDataSource.updateProfile(
        name: name,
        phone: phone,
        photoPath: photoPath,
      );

      await _localDataSource.saveUser(response.data);
      return response.data;
    }, policy: RepositoryErrorPolicy.serverOnly);
  }

  @override
  Future<Result<void>> deleteAccount() {
    return RepositoryExecutor.runSafely(() async {
      await _remoteDataSource.deleteAccount();
      await _localDataSource.clear();
    }, policy: RepositoryErrorPolicy.serverOnly);
  }

  @override
  Future<UserEntity?> getUser() async {
    return _localDataSource.getUser();
  }

  @override
  Future<Result<String>> forgotPassword(String email) {
    return RepositoryExecutor.runSafely(
      () => _remoteDataSource.forgotPassword(email),
    );
  }

  @override
  Future<Result<String>> verifyOtp({
    required String email,
    required String otp,
  }) {
    return RepositoryExecutor.runSafely(
      () => _remoteDataSource.verifyOtp(email: email, otp: otp),
    );
  }

  @override
  Future<Result<String>> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) {
    return RepositoryExecutor.runSafely(
      () => _remoteDataSource.resetPassword(
        email: email,
        otp: otp,
        newPassword: newPassword,
      ),
    );
  }
}
