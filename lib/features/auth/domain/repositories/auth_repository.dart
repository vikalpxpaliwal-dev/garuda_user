import 'package:garuda_user_app/core/utils/result.dart';
import 'package:garuda_user_app/features/auth/data/models/login_request_model.dart';
import 'package:garuda_user_app/features/auth/data/models/signup_request_model.dart';
import 'package:garuda_user_app/features/auth/domain/entities/user_entity.dart';

abstract interface class AuthRepository {
  Future<Result<UserEntity>> signup(SignupRequestModel request);
  Future<Result<UserEntity>> login(LoginRequestModel request);
  Future<Result<String>> refreshToken();
  Future<void> logout();
  Future<String?> getAccessToken();
  Future<Result<UserEntity>> updateProfile({
    required String name,
    required String phone,
    String? photoPath,
  });
  Future<Result<void>> deleteAccount();
}
