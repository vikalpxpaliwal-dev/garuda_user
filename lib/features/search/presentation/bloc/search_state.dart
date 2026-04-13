import 'package:equatable/equatable.dart';
import 'package:garuda_user_app/features/search/domain/entities/land_entity.dart';

enum SearchStatus { initial, loading, success, failure }
enum WishlistStatus { initial, loading, success, failure }

class SearchState extends Equatable {
  static const Object _unset = Object();

  final SearchStatus status;
  final List<LandEntity> lands;
  final String? errorMessage;
  final WishlistStatus wishlistStatus;
  final List<int> wishlistedLandIds;
  final int? activeWishlistLandId;
  final String? wishlistMessage;

  const SearchState({
    this.status = SearchStatus.initial,
    this.lands = const [],
    this.errorMessage,
    this.wishlistStatus = WishlistStatus.initial,
    this.wishlistedLandIds = const [],
    this.activeWishlistLandId,
    this.wishlistMessage,
  });

  SearchState copyWith({
    SearchStatus? status,
    List<LandEntity>? lands,
    Object? errorMessage = _unset,
    WishlistStatus? wishlistStatus,
    List<int>? wishlistedLandIds,
    Object? activeWishlistLandId = _unset,
    Object? wishlistMessage = _unset,
  }) {
    return SearchState(
      status: status ?? this.status,
      lands: lands ?? this.lands,
      errorMessage: identical(errorMessage, _unset)
          ? this.errorMessage
          : errorMessage as String?,
      wishlistStatus: wishlistStatus ?? this.wishlistStatus,
      wishlistedLandIds: wishlistedLandIds ?? this.wishlistedLandIds,
      activeWishlistLandId: identical(activeWishlistLandId, _unset)
          ? this.activeWishlistLandId
          : activeWishlistLandId as int?,
      wishlistMessage: identical(wishlistMessage, _unset)
          ? this.wishlistMessage
          : wishlistMessage as String?,
    );
  }

  @override
  List<Object?> get props => [
        status,
        lands,
        errorMessage,
        wishlistStatus,
        wishlistedLandIds,
        activeWishlistLandId,
        wishlistMessage,
      ];
}
