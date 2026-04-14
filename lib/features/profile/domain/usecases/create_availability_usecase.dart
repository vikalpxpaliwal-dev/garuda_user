import 'package:garuda_user_app/core/utils/result.dart';
import 'package:garuda_user_app/features/profile/domain/repositories/profile_repository.dart';

class CreateAvailabilityUseCase {
  const CreateAvailabilityUseCase(this._repository);

  final ProfileRepository _repository;

  Future<Result<String>> call(List<int> landIds) async {
    return _repository.createAvailability(landIds: landIds);
  }
}
