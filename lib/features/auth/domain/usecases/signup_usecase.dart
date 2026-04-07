import 'package:garuda_user_app/core/utils/result.dart';
import 'package:garuda_user_app/features/auth/data/models/signup_request_model.dart';
import 'package:garuda_user_app/features/auth/domain/entities/user_entity.dart';
import 'package:garuda_user_app/features/auth/domain/repositories/auth_repository.dart';

class SignupUseCase {
  const SignupUseCase(this._repository);

  final AuthRepository _repository;

  Future<Result<UserEntity>> call(SignupRequestModel params) {
    return _repository.signup(params);
  }
}
