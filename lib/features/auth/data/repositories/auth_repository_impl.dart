import 'package:garuda_user_app/core/error/exceptions.dart';
import 'package:garuda_user_app/core/error/failures.dart';
import 'package:garuda_user_app/core/utils/result.dart';
import 'package:garuda_user_app/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:garuda_user_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:garuda_user_app/features/auth/data/models/login_request_model.dart';
import 'package:garuda_user_app/features/auth/data/models/signup_request_model.dart';
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
  Future<Result<UserEntity>> signup(SignupRequestModel request) async {
    try {
      final response = await _remoteDataSource.signup(request);
      return Success(response.data);
    } on AppException catch (e) {
      if (e is NetworkException) {
        return Error(NetworkFailure(message: e.message, statusCode: e.statusCode));
      }
      return Error(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e) {
      return Error(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<UserEntity>> login(LoginRequestModel request) async {
    try {
      final response = await _remoteDataSource.login(request);
      
      // Persist tokens and user data
      await _localDataSource.saveTokens(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
      );
      await _localDataSource.saveUser(response.data);

      return Success(response.data);
    } on AppException catch (e) {
      if (e is NetworkException) {
        return Error(NetworkFailure(message: e.message, statusCode: e.statusCode));
      }
      return Error(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e) {
      return Error(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<String>> refreshToken() async {
    try {
      final refreshToken = await _localDataSource.getRefreshToken();
      if (refreshToken == null) {
        return Error(const ServerFailure(message: 'No refresh token available'));
      }

      final newAccessToken = await _remoteDataSource.refresh(refreshToken);
      await _localDataSource.saveTokens(
        accessToken: newAccessToken,
        refreshToken: refreshToken,
      );

      return Success(newAccessToken);
    } on AppException catch (e) {
      return Error(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e) {
      return Error(ServerFailure(message: e.toString()));
    }
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
    } catch (e) {
      // Even if API fails, we should clear local data and return success 
      // from the user's perspective, or return an error if we really need to.
      // Usually, logout should be best effort remote + certain local clear.
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
  }) async {
    try {
      final response = await _remoteDataSource.updateProfile(
        name: name,
        phone: phone,
        photoPath: photoPath,
      );

      // Update local storage with updated user data
      await _localDataSource.saveUser(response.data);

      return Success(response.data);
    } on AppException catch (e) {
      return Error(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e) {
      return Error(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> deleteAccount() async {
    try {
      await _remoteDataSource.deleteAccount();
      await _localDataSource.clear();
      return const Success(null);
    } on AppException catch (e) {
      return Error(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e) {
      return Error(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<UserEntity?> getUser() async {
    return _localDataSource.getUser();
  }
}

