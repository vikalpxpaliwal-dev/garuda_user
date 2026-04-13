import 'package:garuda_user_app/core/utils/result.dart';
import 'package:garuda_user_app/features/profile/domain/entities/wishlist_item_entity.dart';
import 'package:garuda_user_app/features/profile/domain/repositories/profile_repository.dart';

class GetWishlistUseCase {
  const GetWishlistUseCase(this._repository);

  final ProfileRepository _repository;

  Future<Result<List<WishlistItemEntity>>> call() {
    return _repository.getWishlist();
  }
}
