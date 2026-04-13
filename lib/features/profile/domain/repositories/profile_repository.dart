import 'package:garuda_user_app/core/utils/result.dart';
import 'package:garuda_user_app/features/profile/domain/entities/wishlist_item_entity.dart';

abstract interface class ProfileRepository {
  Future<Result<List<WishlistItemEntity>>> getWishlist();
}
