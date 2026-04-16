import 'package:garuda_user_app/core/utils/result.dart';
import 'package:garuda_user_app/features/profile/domain/entities/shortlist_item_entity.dart';
import 'package:garuda_user_app/features/profile/domain/repositories/profile_repository.dart';

class GetFinalsUseCase {
  const GetFinalsUseCase(this._repository);

  final ProfileRepository _repository;

  Future<Result<List<ShortlistItemEntity>>> call() {
    return _repository.getFinals();
  }
}
