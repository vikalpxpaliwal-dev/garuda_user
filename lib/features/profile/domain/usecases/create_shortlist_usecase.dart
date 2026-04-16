import 'package:garuda_user_app/core/utils/result.dart';
import 'package:garuda_user_app/features/profile/domain/repositories/profile_repository.dart';

class CreateShortlistUseCase {
  const CreateShortlistUseCase(this._repository);

  final ProfileRepository _repository;

  Future<Result<String>> call({required int landId}) {
    return _repository.createShortlist(landId: landId);
  }
}
