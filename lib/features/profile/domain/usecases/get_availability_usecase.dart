import 'package:garuda_user_app/core/utils/result.dart';
import 'package:garuda_user_app/features/profile/domain/entities/availability_entity.dart';
import 'package:garuda_user_app/features/profile/domain/repositories/profile_repository.dart';

class GetAvailabilityUseCase {
  const GetAvailabilityUseCase(this._repository);

  final ProfileRepository _repository;

  Future<Result<List<AvailabilityEntity>>> call() {
    return _repository.getAvailabilities();
  }
}
