import 'package:garuda_user_app/core/utils/result.dart';
import 'package:garuda_user_app/features/profile/domain/entities/shortlist_item_entity.dart';
import 'package:garuda_user_app/features/profile/domain/repositories/profile_repository.dart';

class GetShortlistsUseCase {
  const GetShortlistsUseCase(this._repository);

  final ProfileRepository _repository;

  Future<Result<List<ShortlistItemEntity>>> call() {
    return _repository.getShortlists();
  }
}
