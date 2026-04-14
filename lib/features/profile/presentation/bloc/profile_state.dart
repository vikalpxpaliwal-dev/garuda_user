import 'package:equatable/equatable.dart';
import 'package:garuda_user_app/features/auth/domain/entities/user_entity.dart';
import 'package:garuda_user_app/features/profile/domain/entities/wishlist_item_entity.dart';

enum ProfileStatus { initial, loading, success, failure }
enum ProfileWishlistStatus { initial, loading, success, failure }
enum CreateAvailabilityStatus { initial, loading, success, failure }

class ProfileState extends Equatable {
  static const Object _unset = Object();

  const ProfileState({
    this.status = ProfileStatus.initial,
    this.user,
    this.errorMessage,
    this.wishlistStatus = ProfileWishlistStatus.initial,
    this.wishlistItems = const <WishlistItemEntity>[],
    this.wishlistErrorMessage,
    this.availabilityStatus = CreateAvailabilityStatus.initial,
    this.availabilityErrorMessage,
  });

  final ProfileStatus status;
  final UserEntity? user;
  final String? errorMessage;
  final ProfileWishlistStatus wishlistStatus;
  final List<WishlistItemEntity> wishlistItems;
  final String? wishlistErrorMessage;
  final CreateAvailabilityStatus availabilityStatus;
  final String? availabilityErrorMessage;

  ProfileState copyWith({
    ProfileStatus? status,
    UserEntity? user,
    Object? errorMessage = _unset,
    ProfileWishlistStatus? wishlistStatus,
    List<WishlistItemEntity>? wishlistItems,
    Object? wishlistErrorMessage = _unset,
    CreateAvailabilityStatus? availabilityStatus,
    Object? availabilityErrorMessage = _unset,
  }) {
    return ProfileState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: identical(errorMessage, _unset)
          ? this.errorMessage
          : errorMessage as String?,
      wishlistStatus: wishlistStatus ?? this.wishlistStatus,
      wishlistItems: wishlistItems ?? this.wishlistItems,
      wishlistErrorMessage: identical(wishlistErrorMessage, _unset)
          ? this.wishlistErrorMessage
          : wishlistErrorMessage as String?,
      availabilityStatus: availabilityStatus ?? this.availabilityStatus,
      availabilityErrorMessage: identical(availabilityErrorMessage, _unset)
          ? this.availabilityErrorMessage
          : availabilityErrorMessage as String?,
    );
  }

  @override
  List<Object?> get props => [
        status,
        user,
        errorMessage,
        wishlistStatus,
        wishlistItems,
        wishlistErrorMessage,
        availabilityStatus,
        availabilityErrorMessage,
      ];
}
