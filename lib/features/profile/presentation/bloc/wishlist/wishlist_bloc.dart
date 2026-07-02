import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garuda_user_app/core/utils/result.dart';
import 'package:garuda_user_app/features/profile/domain/usecases/get_wishlist_usecase.dart';
import 'package:garuda_user_app/features/profile/presentation/bloc/wishlist/wishlist_event.dart';
import 'package:garuda_user_app/features/profile/presentation/bloc/wishlist/wishlist_state.dart';

class WishlistBloc extends Bloc<WishlistEvent, WishlistState> {
  WishlistBloc({required GetWishlistUseCase getWishlistUseCase})
      : _getWishlistUseCase = getWishlistUseCase,
        super(const WishlistState()) {
    on<WishlistRequested>(_onWishlistRequested);
  }

  final GetWishlistUseCase _getWishlistUseCase;

  Future<void> _onWishlistRequested(
    WishlistRequested event,
    Emitter<WishlistState> emit,
  ) async {
    emit(state.copyWith(status: WishlistStatus.loading, errorMessage: null));

    final result = await _getWishlistUseCase();

    switch (result) {
      case Success(data: final items):
        emit(state.copyWith(
          status: WishlistStatus.success,
          items: items,
          errorMessage: null,
        ));
      case Error(failure: final failure):
        emit(state.copyWith(
          status: WishlistStatus.failure,
          errorMessage: failure.message,
        ));
    }
  }
}
