import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garuda_user_app/core/utils/result.dart';
import 'package:garuda_user_app/features/auth/domain/usecases/delete_account_usecase.dart';
import 'package:garuda_user_app/features/auth/domain/usecases/update_profile_usecase.dart';
import 'package:garuda_user_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:garuda_user_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:garuda_user_app/features/profile/domain/usecases/create_availability_usecase.dart';
import 'package:garuda_user_app/features/profile/domain/usecases/get_wishlist_usecase.dart';
import 'package:garuda_user_app/features/profile/presentation/bloc/profile_event.dart';
import 'package:garuda_user_app/features/profile/presentation/bloc/profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc({
    required UpdateProfileUseCase updateProfileUseCase,
    required DeleteAccountUseCase deleteAccountUseCase,
    required GetWishlistUseCase getWishlistUseCase,
    required CreateAvailabilityUseCase createAvailabilityUseCase,
    required AuthBloc authBloc,
  })  : _updateProfileUseCase = updateProfileUseCase,
        _deleteAccountUseCase = deleteAccountUseCase,
        _getWishlistUseCase = getWishlistUseCase,
        _createAvailabilityUseCase = createAvailabilityUseCase,
        _authBloc = authBloc,
        super(const ProfileState()) {
    on<UpdateProfileRequested>(_onUpdateProfileRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<DeleteAccountRequested>(_onDeleteAccountRequested);
    on<WishlistRequested>(_onWishlistRequested);
    on<CreateAvailabilityRequested>(_onCreateAvailabilityRequested);
  }

  final UpdateProfileUseCase _updateProfileUseCase;
  final DeleteAccountUseCase _deleteAccountUseCase;
  final GetWishlistUseCase _getWishlistUseCase;
  final CreateAvailabilityUseCase _createAvailabilityUseCase;
  final AuthBloc _authBloc;

  Future<void> _onUpdateProfileRequested(
    UpdateProfileRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(status: ProfileStatus.loading));

    final result = await _updateProfileUseCase(
      name: event.name,
      phone: event.phone,
      photoPath: event.photoPath,
    );

    if (result is Success) {
      emit(state.copyWith(status: ProfileStatus.success, user: (result as Success).data));
    } else {
      emit(state.copyWith(
        status: ProfileStatus.failure,
        errorMessage: (result as Error).failure.message,
      ));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<ProfileState> emit,
  ) async {
    _authBloc.add(UserLoggedOut());
  }

  Future<void> _onDeleteAccountRequested(
    DeleteAccountRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(status: ProfileStatus.loading));

    final result = await _deleteAccountUseCase();

    if (result is Success) {
      _authBloc.add(UserLoggedOut());
    } else {
      emit(state.copyWith(
        status: ProfileStatus.failure,
        errorMessage: (result as Error).failure.message,
      ));
    }
  }

  Future<void> _onWishlistRequested(
    WishlistRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(
      state.copyWith(
        wishlistStatus: ProfileWishlistStatus.loading,
        wishlistErrorMessage: null,
      ),
    );

    final result = await _getWishlistUseCase();

    switch (result) {
      case Success(data: final wishlistItems):
        emit(
          state.copyWith(
            wishlistStatus: ProfileWishlistStatus.success,
            wishlistItems: wishlistItems,
            wishlistErrorMessage: null,
          ),
        );
      case Error(failure: final failure):
        emit(
          state.copyWith(
            wishlistStatus: ProfileWishlistStatus.failure,
            wishlistErrorMessage: failure.message,
          ),
        );
    }
  }

  Future<void> _onCreateAvailabilityRequested(
    CreateAvailabilityRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(
      state.copyWith(
        availabilityStatus: CreateAvailabilityStatus.loading,
        availabilityErrorMessage: null,
      ),
    );

    final result = await _createAvailabilityUseCase(event.landIds);

    switch (result) {
      case Success():
        emit(
          state.copyWith(
            availabilityStatus: CreateAvailabilityStatus.success,
            availabilityErrorMessage: null,
          ),
        );
        // Refresh wishlist after success
        add(const WishlistRequested());
      case Error(failure: final failure):
        emit(
          state.copyWith(
            availabilityStatus: CreateAvailabilityStatus.failure,
            availabilityErrorMessage: failure.message,
          ),
        );
    }
  }
}
