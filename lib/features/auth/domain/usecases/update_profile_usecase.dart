import 'package:garuda_user_app/core/utils/result.dart';
import 'package:garuda_user_app/features/auth/domain/entities/user_entity.dart';
import 'package:garuda_user_app/features/auth/domain/repositories/auth_repository.dart';

class UpdateProfileUseCase {
  UpdateProfileUseCase(this._repository);

  final AuthRepository _repository;

  Future<Result<UserEntity>> call({
    required String name,
    required String phone,
    String? photoPath,
  }) {
    return _repository.updateProfile(
      name: name,
      phone: phone,
      photoPath: photoPath,
    );
  }
}
