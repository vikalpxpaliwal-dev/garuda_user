import 'package:garuda_user_app/core/utils/result.dart';
import 'package:garuda_user_app/features/auth/domain/repositories/auth_repository.dart';

class DeleteAccountUseCase {
  DeleteAccountUseCase(this._repository);

  final AuthRepository _repository;

  Future<Result<void>> call() {
    return _repository.deleteAccount();
  }
}
