import 'package:garuda_user_app/core/utils/result.dart';
import 'package:garuda_user_app/features/profile/domain/entities/availability_entity.dart';
import 'package:garuda_user_app/features/profile/domain/entities/cart_item_entity.dart';
import 'package:garuda_user_app/features/profile/domain/entities/wishlist_item_entity.dart';

abstract interface class ProfileRepository {
  Future<Result<List<WishlistItemEntity>>> getWishlist();
  Future<Result<String>> createAvailability({required List<int> landIds});
  Future<Result<List<AvailabilityEntity>>> getAvailabilities();
  Future<Result<String>> createCart({required List<int> landIds});
  Future<Result<List<CartItemEntity>>> getCart();
  Future<Result<String>> createPayment({
    required List<int> landIds,
    required int amount,
    required String paymentStatus,
  });
  Future<Result<String>> createVisit({
    required List<int> landIds,
    required String visitDate,
    required String time,
    required String meetingStatus,
  });
}
