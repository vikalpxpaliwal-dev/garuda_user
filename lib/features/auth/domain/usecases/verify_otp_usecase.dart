import 'package:garuda_user_app/core/utils/result.dart';
import 'package:garuda_user_app/features/auth/domain/repositories/auth_repository.dart';

class VerifyOtpUseCase {
  const VerifyOtpUseCase(this._repository);

  final AuthRepository _repository;

  Future<Result<String>> call({
    required String email,
    required String otp,
  }) async {
    return _repository.verifyOtp(email: email, otp: otp);
  }
}
