import 'package:garuda_user_app/core/utils/result.dart';
import 'package:garuda_user_app/features/profile/domain/entities/visit_item_entity.dart';
import 'package:garuda_user_app/features/profile/domain/repositories/profile_repository.dart';

class GetVisitsUseCase {
  const GetVisitsUseCase(this._repository);

  final ProfileRepository _repository;

  Future<Result<List<VisitItemEntity>>> call() {
    return _repository.getVisits();
  }
}
