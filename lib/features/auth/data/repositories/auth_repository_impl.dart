import 'package:garuda_user_app/core/error/exceptions.dart';
import 'package:garuda_user_app/core/error/failures.dart';
import 'package:garuda_user_app/core/utils/result.dart';
import 'package:garuda_user_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:garuda_user_app/features/auth/data/models/signup_request_model.dart';
import 'package:garuda_user_app/features/auth/domain/entities/user_entity.dart';
import 'package:garuda_user_app/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl({required AuthRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  final AuthRemoteDataSource _remoteDataSource;

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
}
