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
}

