import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garuda_user_app/core/utils/result.dart';
import 'package:garuda_user_app/features/profile/domain/usecases/add_to_wishlist_usecase.dart';
import 'package:garuda_user_app/features/profile/domain/usecases/get_wishlist_usecase.dart';
import 'package:garuda_user_app/features/search/domain/usecases/get_land_by_id_usecase.dart';
import 'package:garuda_user_app/features/search/domain/usecases/get_lands_usecase.dart';
import 'package:garuda_user_app/features/search/domain/usecases/get_locations_usecase.dart';
import 'package:garuda_user_app/features/search/presentation/bloc/search_event.dart';
import 'package:garuda_user_app/features/search/presentation/bloc/search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc({
    required GetLandsUseCase getLandsUseCase,
    required AddToWishlistUseCase addToWishlistUseCase,
    required GetWishlistUseCase getWishlistUseCase,
    required GetLocationsUseCase getLocationsUseCase,
    required GetLandByIdUseCase getLandByIdUseCase,
  })  : _getLandsUseCase = getLandsUseCase,
        _addToWishlistUseCase = addToWishlistUseCase,
        _getWishlistUseCase = getWishlistUseCase,
        _getLocationsUseCase = getLocationsUseCase,
        _getLandByIdUseCase = getLandByIdUseCase,
        super(const SearchState()) {
    on<GetLandsEvent>(_onGetLands);
    on<GetLocationsEvent>(_onGetLocations);
    on<LoadWishlistedLandIdsEvent>(_onLoadWishlistedLandIds);
    on<LoadLandDetailEvent>(_onLoadLandDetail);
    on<AddToWishlistEvent>(_onAddToWishlist);
    on<AddSelectedToWishlistEvent>(_onAddSelectedToWishlist);
  }

  final GetLandsUseCase _getLandsUseCase;
  final AddToWishlistUseCase _addToWishlistUseCase;
  final GetWishlistUseCase _getWishlistUseCase;
  final GetLocationsUseCase _getLocationsUseCase;
  final GetLandByIdUseCase _getLandByIdUseCase;

  Future<List<int>> _fetchWishlistedLandIds() async {
    final result = await _getWishlistUseCase();
    return switch (result) {
      Success(data: final items) => items.map((item) => item.landId).toList(),
      Error() => state.wishlistedLandIds,
    };
  }

  Future<void> _onLoadWishlistedLandIds(
    LoadWishlistedLandIdsEvent event,
    Emitter<SearchState> emit,
  ) async {
    final wishlistedLandIds = await _fetchWishlistedLandIds();
    emit(state.copyWith(wishlistedLandIds: wishlistedLandIds));
  }

  Future<void> _onLoadLandDetail(
    LoadLandDetailEvent event,
    Emitter<SearchState> emit,
  ) async {
    final cached = state.landForId(event.landId);
    if (cached != null) {
      emit(
        state.copyWith(
          landDetailStatus: LandDetailStatus.success,
          landDetail: cached,
          landDetailId: event.landId,
          landDetailErrorMessage: null,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        landDetailStatus: LandDetailStatus.loading,
        landDetailId: event.landId,
        landDetailErrorMessage: null,
      ),
    );

    final result = await _getLandByIdUseCase(event.landId);

    switch (result) {
      case Success(data: final land) when land != null:
        emit(
          state.copyWith(
            landDetailStatus: LandDetailStatus.success,
            landDetail: land,
            landDetailId: event.landId,
            landDetailErrorMessage: null,
          ),
        );
      case Success():
        emit(
          state.copyWith(
            landDetailStatus: LandDetailStatus.failure,
            landDetailId: event.landId,
            landDetailErrorMessage: 'Land not found.',
          ),
        );
      case Error(failure: final failure):
        emit(
          state.copyWith(
            landDetailStatus: LandDetailStatus.failure,
            landDetailId: event.landId,
            landDetailErrorMessage: failure.message,
          ),
        );
    }
  }

  Future<void> _onGetLands(
    GetLandsEvent event,
    Emitter<SearchState> emit,
  ) async {
    emit(state.copyWith(status: SearchStatus.loading));

    final result = await _getLandsUseCase(filters: event.filters);

    switch (result) {
      case Success(data: final lands):
        emit(state.copyWith(
          status: SearchStatus.success,
          lands: lands,
        ));
      case Error(failure: final f):
        emit(state.copyWith(
          status: SearchStatus.failure,
          errorMessage: f.message,
        ));
    }

    // Refresh wishlist highlighting separately so a wishlist API problem
    // never blocks the land listing from rendering.
    final wishlistedLandIds = await _fetchWishlistedLandIds();
    emit(state.copyWith(wishlistedLandIds: wishlistedLandIds));
  }

  Future<void> _onGetLocations(
    GetLocationsEvent event,
    Emitter<SearchState> emit,
  ) async {
    emit(state.copyWith(locationStatus: LocationStatus.loading));

    final result = await _getLocationsUseCase();

    switch (result) {
      case Success(data: final states):
        emit(state.copyWith(
          locationStatus: LocationStatus.success,
          states: states,
        ));
      case Error(failure: final f):
        emit(state.copyWith(
          locationStatus: LocationStatus.failure,
          errorMessage: f.message,
        ));
    }
  }

  Future<void> _onAddToWishlist(
    AddToWishlistEvent event,
    Emitter<SearchState> emit,
  ) async {
    final isAlreadyWishlisted = state.wishlistedLandIds.contains(event.landId);
    final isAlreadyLoading =
        state.wishlistStatus == WishlistStatus.loading &&
        state.activeWishlistLandId == event.landId;

    if (isAlreadyWishlisted || isAlreadyLoading) {
      return;
    }

    emit(
      state.copyWith(
        wishlistStatus: WishlistStatus.loading,
        activeWishlistLandId: event.landId,
        wishlistMessage: null,
      ),
    );

    final result = await _addToWishlistUseCase(landIds: <int>[event.landId]);

    switch (result) {
      case Success(data: final message):
        final wishlistedLandIds = await _fetchWishlistedLandIds();
        emit(
          state.copyWith(
            wishlistStatus: WishlistStatus.success,
            wishlistedLandIds: wishlistedLandIds,
            activeWishlistLandId: event.landId,
            wishlistMessage: message,
          ),
        );
      case Error(failure: final failure):
        emit(
          state.copyWith(
            wishlistStatus: WishlistStatus.failure,
            activeWishlistLandId: event.landId,
            wishlistMessage: failure.message,
          ),
        );
    }
  }

  Future<void> _onAddSelectedToWishlist(
    AddSelectedToWishlistEvent event,
    Emitter<SearchState> emit,
  ) async {
    final uniqueLandIds = event.landIds.toSet().toList();
    final filteredLandIds = uniqueLandIds
        .where((landId) => !state.wishlistedLandIds.contains(landId))
        .toList();

    if (filteredLandIds.isEmpty) {
      emit(
        state.copyWith(
          wishlistStatus: WishlistStatus.failure,
          activeWishlistLandId: null,
          wishlistMessage: 'Please select lands that are not already wishlisted.',
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        wishlistStatus: WishlistStatus.loading,
        activeWishlistLandId: null,
        wishlistMessage: null,
      ),
    );

    final result = await _addToWishlistUseCase(landIds: filteredLandIds);

    switch (result) {
      case Success(data: final message):
        final wishlistedLandIds = await _fetchWishlistedLandIds();
        emit(
          state.copyWith(
            wishlistStatus: WishlistStatus.success,
            wishlistedLandIds: wishlistedLandIds,
            activeWishlistLandId: null,
            wishlistMessage: message,
          ),
        );
      case Error(failure: final failure):
        emit(
          state.copyWith(
            wishlistStatus: WishlistStatus.failure,
            activeWishlistLandId: null,
            wishlistMessage: failure.message,
          ),
        );
    }
  }
}
