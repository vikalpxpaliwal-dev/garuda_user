import 'package:equatable/equatable.dart';
import 'package:garuda_user_app/features/auth/domain/entities/user_entity.dart';
import 'package:garuda_user_app/features/profile/domain/entities/availability_entity.dart';
import 'package:garuda_user_app/features/profile/domain/entities/cart_item_entity.dart';
import 'package:garuda_user_app/features/profile/domain/entities/wishlist_item_entity.dart';

enum ProfileStatus { initial, loading, success, failure }
enum ProfileWishlistStatus { initial, loading, success, failure }
enum CreateAvailabilityStatus { initial, loading, success, failure }
enum GetAvailabilityStatus { initial, loading, success, failure }
enum CreateCartStatus { initial, loading, success, failure }
enum GetCartStatus { initial, loading, success, failure }
enum CreatePaymentStatus { initial, loading, success, failure }
enum CreateVisitStatus { initial, loading, success, failure }

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
    this.getAvailabilityStatus = GetAvailabilityStatus.initial,
    this.availabilityErrorMessage,
    this.availabilityItems = const <AvailabilityEntity>[],
    this.cartStatus = CreateCartStatus.initial,
    this.cartErrorMessage,
    this.getCartStatus = GetCartStatus.initial,
    this.cartItems = const <CartItemEntity>[],
    this.cartItemsErrorMessage,
    this.paymentStatus = CreatePaymentStatus.initial,
    this.paymentErrorMessage,
    this.visitStatus = CreateVisitStatus.initial,
    this.visitErrorMessage,
  });

  final ProfileStatus status;
  final UserEntity? user;
  final String? errorMessage;
  final ProfileWishlistStatus wishlistStatus;
  final List<WishlistItemEntity> wishlistItems;
  final String? wishlistErrorMessage;
  final CreateAvailabilityStatus availabilityStatus;
  final GetAvailabilityStatus getAvailabilityStatus;
  final String? availabilityErrorMessage;
  final List<AvailabilityEntity> availabilityItems;
  final CreateCartStatus cartStatus;
  final String? cartErrorMessage;
  final GetCartStatus getCartStatus;
  final List<CartItemEntity> cartItems;
  final String? cartItemsErrorMessage;
  final CreatePaymentStatus paymentStatus;
  final String? paymentErrorMessage;
  final CreateVisitStatus visitStatus;
  final String? visitErrorMessage;

  ProfileState copyWith({
    ProfileStatus? status,
    UserEntity? user,
    Object? errorMessage = _unset,
    ProfileWishlistStatus? wishlistStatus,
    List<WishlistItemEntity>? wishlistItems,
    Object? wishlistErrorMessage = _unset,
    CreateAvailabilityStatus? availabilityStatus,
    GetAvailabilityStatus? getAvailabilityStatus,
    Object? availabilityErrorMessage = _unset,
    List<AvailabilityEntity>? availabilityItems,
    CreateCartStatus? cartStatus,
    Object? cartErrorMessage = _unset,
    GetCartStatus? getCartStatus,
    List<CartItemEntity>? cartItems,
    Object? cartItemsErrorMessage = _unset,
    CreatePaymentStatus? paymentStatus,
    Object? paymentErrorMessage = _unset,
    CreateVisitStatus? visitStatus,
    Object? visitErrorMessage = _unset,
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
      getAvailabilityStatus: getAvailabilityStatus ?? this.getAvailabilityStatus,
      availabilityErrorMessage: identical(availabilityErrorMessage, _unset)
          ? this.availabilityErrorMessage
          : availabilityErrorMessage as String?,
      availabilityItems: availabilityItems ?? this.availabilityItems,
      cartStatus: cartStatus ?? this.cartStatus,
      cartErrorMessage: identical(cartErrorMessage, _unset)
          ? this.cartErrorMessage
          : cartErrorMessage as String?,
      getCartStatus: getCartStatus ?? this.getCartStatus,
      cartItems: cartItems ?? this.cartItems,
      cartItemsErrorMessage: identical(cartItemsErrorMessage, _unset)
          ? this.cartItemsErrorMessage
          : cartItemsErrorMessage as String?,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      paymentErrorMessage: identical(paymentErrorMessage, _unset)
          ? this.paymentErrorMessage
          : paymentErrorMessage as String?,
      visitStatus: visitStatus ?? this.visitStatus,
      visitErrorMessage: identical(visitErrorMessage, _unset)
          ? this.visitErrorMessage
          : visitErrorMessage as String?,
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
        getAvailabilityStatus,
        availabilityErrorMessage,
        availabilityItems,
        cartStatus,
        cartErrorMessage,
        getCartStatus,
        cartItems,
        cartItemsErrorMessage,
        paymentStatus,
        paymentErrorMessage,
        visitStatus,
        visitErrorMessage,
      ];
}
