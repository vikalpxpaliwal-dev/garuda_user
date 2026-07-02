import 'package:garuda_user_app/core/utils/result.dart';
import 'package:garuda_user_app/features/auth/domain/entities/login_credentials.dart';
import 'package:garuda_user_app/features/auth/domain/entities/signup_credentials.dart';
import 'package:garuda_user_app/features/auth/domain/entities/user_entity.dart';

abstract interface class AuthRepository {
  Future<Result<UserEntity>> signup(SignupCredentials credentials);
  Future<Result<UserEntity>> login(LoginCredentials credentials);
  Future<Result<String>> refreshToken();
  Future<void> clearSession();
  Future<Result<void>> logout();
  Future<String?> getAccessToken();
  Future<Result<UserEntity>> updateProfile({
    required String name,
    required String phone,
    String? photoPath,
  });
  Future<Result<void>> deleteAccount();
  Future<UserEntity?> getUser();
  Future<Result<String>> forgotPassword(String email);
  Future<Result<String>> verifyOtp({required String email, required String otp});
  Future<Result<String>> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  });
}
