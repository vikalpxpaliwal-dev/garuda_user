import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garuda_user_app/core/utils/result.dart';
import 'package:garuda_user_app/features/search/domain/usecases/add_to_wishlist_usecase.dart';
import 'package:garuda_user_app/features/search/domain/usecases/get_lands_usecase.dart';
import 'package:garuda_user_app/features/search/domain/usecases/get_locations_usecase.dart';
import 'package:garuda_user_app/features/search/presentation/bloc/search_event.dart';
import 'package:garuda_user_app/features/search/presentation/bloc/search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final GetLandsUseCase _getLandsUseCase;
  final AddToWishlistUseCase _addToWishlistUseCase;
  final GetLocationsUseCase _getLocationsUseCase;

  SearchBloc({
    required GetLandsUseCase getLandsUseCase,
    required AddToWishlistUseCase addToWishlistUseCase,
    required GetLocationsUseCase getLocationsUseCase,
  })  : _getLandsUseCase = getLandsUseCase,
        _addToWishlistUseCase = addToWishlistUseCase,
        _getLocationsUseCase = getLocationsUseCase,
        super(const SearchState()) {
    on<GetLandsEvent>(_onGetLands);
    on<GetLocationsEvent>(_onGetLocations);
    on<AddToWishlistEvent>(_onAddToWishlist);
    on<AddSelectedToWishlistEvent>(_onAddSelectedToWishlist);
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
        final updatedWishlistedLandIds = <int>{
          ...state.wishlistedLandIds,
          event.landId,
        }.toList();

        emit(
          state.copyWith(
            wishlistStatus: WishlistStatus.success,
            wishlistedLandIds: updatedWishlistedLandIds,
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
        final updatedWishlistedLandIds = <int>{
          ...state.wishlistedLandIds,
          ...filteredLandIds,
        }.toList();

        emit(
          state.copyWith(
            wishlistStatus: WishlistStatus.success,
            wishlistedLandIds: updatedWishlistedLandIds,
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
