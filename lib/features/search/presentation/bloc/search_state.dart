import 'package:equatable/equatable.dart';
import 'package:garuda_user_app/features/search/domain/entities/land_entity.dart';
import 'package:garuda_user_app/features/search/domain/entities/location_entity.dart';

enum SearchStatus { initial, loading, success, failure }
enum WishlistStatus { initial, loading, success, failure }
enum LocationStatus { initial, loading, success, failure }

class SearchState extends Equatable {
  static const Object _unset = Object();

  final SearchStatus status;
  final List<LandEntity> lands;
  final String? errorMessage;
  final WishlistStatus wishlistStatus;
  final List<int> wishlistedLandIds;
  final int? activeWishlistLandId;
  final String? wishlistMessage;
  final LocationStatus locationStatus;
  final List<StateEntity> states;

  const SearchState({
    this.status = SearchStatus.initial,
    this.lands = const [],
    this.errorMessage,
    this.wishlistStatus = WishlistStatus.initial,
    this.wishlistedLandIds = const [],
    this.activeWishlistLandId,
    this.wishlistMessage,
    this.locationStatus = LocationStatus.initial,
    this.states = const [],
  });

  SearchState copyWith({
    SearchStatus? status,
    List<LandEntity>? lands,
    Object? errorMessage = _unset,
    WishlistStatus? wishlistStatus,
    List<int>? wishlistedLandIds,
    Object? activeWishlistLandId = _unset,
    Object? wishlistMessage = _unset,
    LocationStatus? locationStatus,
    List<StateEntity>? states,
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
      locationStatus: locationStatus ?? this.locationStatus,
      states: states ?? this.states,
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
        locationStatus,
        states,
      ];
}
