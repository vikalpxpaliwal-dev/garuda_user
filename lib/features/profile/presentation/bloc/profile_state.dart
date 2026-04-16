import 'package:equatable/equatable.dart';
import 'package:garuda_user_app/features/auth/domain/entities/user_entity.dart';
import 'package:garuda_user_app/features/profile/domain/entities/availability_entity.dart';
import 'package:garuda_user_app/features/profile/domain/entities/cart_item_entity.dart';
import 'package:garuda_user_app/features/profile/domain/entities/shortlist_item_entity.dart';
import 'package:garuda_user_app/features/profile/domain/entities/visit_item_entity.dart';
import 'package:garuda_user_app/features/profile/domain/entities/wishlist_item_entity.dart';

enum ProfileStatus { initial, loading, success, failure }
enum ProfileWishlistStatus { initial, loading, success, failure }
enum CreateAvailabilityStatus { initial, loading, success, failure }
enum GetAvailabilityStatus { initial, loading, success, failure }
enum CreateCartStatus { initial, loading, success, failure }
enum GetCartStatus { initial, loading, success, failure }
enum CreatePaymentStatus { initial, loading, success, failure }
enum CreateVisitStatus { initial, loading, success, failure }
enum GetVisitsStatus { initial, loading, success, failure }
enum GetShortlistsStatus { initial, loading, success, failure }
enum GetFinalsStatus { initial, loading, success, failure }
enum CreateShortlistStatus { initial, loading, success, failure }
enum DeleteShortlistStatus { initial, loading, success, failure }
enum CreateFinalStatus { initial, loading, success, failure }
enum DeleteFinalStatus { initial, loading, success, failure }

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
    this.getVisitsStatus = GetVisitsStatus.initial,
    this.visitItems = const <VisitItemEntity>[],
    this.visitItemsErrorMessage,
    this.getShortlistsStatus = GetShortlistsStatus.initial,
    this.shortlistItems = const <ShortlistItemEntity>[],
    this.shortlistItemsErrorMessage,
    this.getFinalsStatus = GetFinalsStatus.initial,
    this.finalItems = const <ShortlistItemEntity>[],
    this.finalItemsErrorMessage,
    this.shortlistStatus = CreateShortlistStatus.initial,
    this.shortlistMessage,
    this.activeShortlistLandId,
    this.shortlistedLandIds = const <int>[],
    this.deleteShortlistStatus = DeleteShortlistStatus.initial,
    this.deleteShortlistMessage,
    this.activeDeleteShortlistLandId,
    this.createFinalStatus = CreateFinalStatus.initial,
    this.finalMessage,
    this.activeFinalLandId,
    this.finalizedLandIds = const <int>[],
    this.deleteFinalStatus = DeleteFinalStatus.initial,
    this.deleteFinalMessage,
    this.activeDeleteFinalLandId,
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
  final GetVisitsStatus getVisitsStatus;
  final List<VisitItemEntity> visitItems;
  final String? visitItemsErrorMessage;
  final GetShortlistsStatus getShortlistsStatus;
  final List<ShortlistItemEntity> shortlistItems;
  final String? shortlistItemsErrorMessage;
  final GetFinalsStatus getFinalsStatus;
  final List<ShortlistItemEntity> finalItems;
  final String? finalItemsErrorMessage;
  final CreateShortlistStatus shortlistStatus;
  final String? shortlistMessage;
  final int? activeShortlistLandId;
  final List<int> shortlistedLandIds;
  final DeleteShortlistStatus deleteShortlistStatus;
  final String? deleteShortlistMessage;
  final int? activeDeleteShortlistLandId;
  final CreateFinalStatus createFinalStatus;
  final String? finalMessage;
  final int? activeFinalLandId;
  final List<int> finalizedLandIds;
  final DeleteFinalStatus deleteFinalStatus;
  final String? deleteFinalMessage;
  final int? activeDeleteFinalLandId;

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
    GetVisitsStatus? getVisitsStatus,
    List<VisitItemEntity>? visitItems,
    Object? visitItemsErrorMessage = _unset,
    GetShortlistsStatus? getShortlistsStatus,
    List<ShortlistItemEntity>? shortlistItems,
    Object? shortlistItemsErrorMessage = _unset,
    GetFinalsStatus? getFinalsStatus,
    List<ShortlistItemEntity>? finalItems,
    Object? finalItemsErrorMessage = _unset,
    CreateShortlistStatus? shortlistStatus,
    Object? shortlistMessage = _unset,
    Object? activeShortlistLandId = _unset,
    List<int>? shortlistedLandIds,
    DeleteShortlistStatus? deleteShortlistStatus,
    Object? deleteShortlistMessage = _unset,
    Object? activeDeleteShortlistLandId = _unset,
    CreateFinalStatus? createFinalStatus,
    Object? finalMessage = _unset,
    Object? activeFinalLandId = _unset,
    List<int>? finalizedLandIds,
    DeleteFinalStatus? deleteFinalStatus,
    Object? deleteFinalMessage = _unset,
    Object? activeDeleteFinalLandId = _unset,
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
      getVisitsStatus: getVisitsStatus ?? this.getVisitsStatus,
      visitItems: visitItems ?? this.visitItems,
      visitItemsErrorMessage: identical(visitItemsErrorMessage, _unset)
          ? this.visitItemsErrorMessage
          : visitItemsErrorMessage as String?,
      getShortlistsStatus: getShortlistsStatus ?? this.getShortlistsStatus,
      shortlistItems: shortlistItems ?? this.shortlistItems,
      shortlistItemsErrorMessage: identical(shortlistItemsErrorMessage, _unset)
          ? this.shortlistItemsErrorMessage
          : shortlistItemsErrorMessage as String?,
      getFinalsStatus: getFinalsStatus ?? this.getFinalsStatus,
      finalItems: finalItems ?? this.finalItems,
      finalItemsErrorMessage: identical(finalItemsErrorMessage, _unset)
          ? this.finalItemsErrorMessage
          : finalItemsErrorMessage as String?,
      shortlistStatus: shortlistStatus ?? this.shortlistStatus,
      shortlistMessage: identical(shortlistMessage, _unset)
          ? this.shortlistMessage
          : shortlistMessage as String?,
      activeShortlistLandId: identical(activeShortlistLandId, _unset)
          ? this.activeShortlistLandId
          : activeShortlistLandId as int?,
      shortlistedLandIds: shortlistedLandIds ?? this.shortlistedLandIds,
      deleteShortlistStatus:
          deleteShortlistStatus ?? this.deleteShortlistStatus,
      deleteShortlistMessage: identical(deleteShortlistMessage, _unset)
          ? this.deleteShortlistMessage
          : deleteShortlistMessage as String?,
      activeDeleteShortlistLandId:
          identical(activeDeleteShortlistLandId, _unset)
              ? this.activeDeleteShortlistLandId
              : activeDeleteShortlistLandId as int?,
      createFinalStatus: createFinalStatus ?? this.createFinalStatus,
      finalMessage: identical(finalMessage, _unset)
          ? this.finalMessage
          : finalMessage as String?,
      activeFinalLandId: identical(activeFinalLandId, _unset)
          ? this.activeFinalLandId
          : activeFinalLandId as int?,
      finalizedLandIds: finalizedLandIds ?? this.finalizedLandIds,
      deleteFinalStatus: deleteFinalStatus ?? this.deleteFinalStatus,
      deleteFinalMessage: identical(deleteFinalMessage, _unset)
          ? this.deleteFinalMessage
          : deleteFinalMessage as String?,
      activeDeleteFinalLandId: identical(activeDeleteFinalLandId, _unset)
          ? this.activeDeleteFinalLandId
          : activeDeleteFinalLandId as int?,
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
        getVisitsStatus,
        visitItems,
        visitItemsErrorMessage,
        getShortlistsStatus,
        shortlistItems,
        shortlistItemsErrorMessage,
        getFinalsStatus,
        finalItems,
        finalItemsErrorMessage,
        shortlistStatus,
        shortlistMessage,
        activeShortlistLandId,
        shortlistedLandIds,
        deleteShortlistStatus,
        deleteShortlistMessage,
        activeDeleteShortlistLandId,
        createFinalStatus,
        finalMessage,
        activeFinalLandId,
        finalizedLandIds,
        deleteFinalStatus,
        deleteFinalMessage,
        activeDeleteFinalLandId,
      ];
}
