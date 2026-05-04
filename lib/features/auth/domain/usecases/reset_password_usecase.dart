import 'package:garuda_user_app/core/utils/result.dart';
import 'package:garuda_user_app/features/auth/domain/repositories/auth_repository.dart';

class ResetPasswordUseCase {
  const ResetPasswordUseCase(this._repository);

  final AuthRepository _repository;

  Future<Result<String>> call({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    return _repository.resetPassword(
      email: email,
      otp: otp,
      newPassword: newPassword,
    );
  }
}
