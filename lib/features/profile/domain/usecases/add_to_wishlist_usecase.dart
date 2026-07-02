import 'package:garuda_user_app/core/utils/result.dart';
import 'package:garuda_user_app/features/profile/domain/repositories/profile_repository.dart';

class AddToWishlistUseCase {
  const AddToWishlistUseCase(this._repository);

  final ProfileRepository _repository;

  Future<Result<String>> call({required List<int> landIds}) {
    return _repository.addToWishlist(landIds: landIds);
  }
}
