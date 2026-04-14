import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garuda_user_app/core/utils/result.dart';
import 'package:garuda_user_app/features/auth/domain/usecases/delete_account_usecase.dart';
import 'package:garuda_user_app/features/auth/domain/usecases/update_profile_usecase.dart';
import 'package:garuda_user_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:garuda_user_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:garuda_user_app/features/profile/domain/usecases/create_availability_usecase.dart';
import 'package:garuda_user_app/features/profile/domain/usecases/create_cart_usecase.dart';
import 'package:garuda_user_app/features/profile/domain/usecases/create_payment_usecase.dart';
import 'package:garuda_user_app/features/profile/domain/usecases/create_visit_usecase.dart';
import 'package:garuda_user_app/features/profile/domain/usecases/get_availability_usecase.dart';
import 'package:garuda_user_app/features/profile/domain/usecases/get_cart_usecase.dart';
import 'package:garuda_user_app/features/profile/domain/usecases/get_wishlist_usecase.dart';
import 'package:garuda_user_app/features/profile/presentation/bloc/profile_event.dart';
import 'package:garuda_user_app/features/profile/presentation/bloc/profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc({
    required UpdateProfileUseCase updateProfileUseCase,
    required DeleteAccountUseCase deleteAccountUseCase,
    required GetWishlistUseCase getWishlistUseCase,
    required CreateAvailabilityUseCase createAvailabilityUseCase,
    required GetAvailabilityUseCase getAvailabilityUseCase,
    required CreateCartUseCase createCartUseCase,
    required GetCartUseCase getCartUseCase,
    required CreatePaymentUseCase createPaymentUseCase,
    required CreateVisitUseCase createVisitUseCase,
    required AuthBloc authBloc,
  })  : _updateProfileUseCase = updateProfileUseCase,
        _deleteAccountUseCase = deleteAccountUseCase,
        _getWishlistUseCase = getWishlistUseCase,
        _createAvailabilityUseCase = createAvailabilityUseCase,
        _getAvailabilityUseCase = getAvailabilityUseCase,
        _createCartUseCase = createCartUseCase,
        _getCartUseCase = getCartUseCase,
        _createPaymentUseCase = createPaymentUseCase,
        _createVisitUseCase = createVisitUseCase,
        _authBloc = authBloc,
        super(const ProfileState()) {
    on<UpdateProfileRequested>(_onUpdateProfileRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<DeleteAccountRequested>(_onDeleteAccountRequested);
    on<WishlistRequested>(_onWishlistRequested);
    on<CreateAvailabilityRequested>(_onCreateAvailabilityRequested);
    on<GetAvailabilitiesRequested>(_onGetAvailabilitiesRequested);
    on<CreateCartRequested>(_onCreateCartRequested);
    on<GetCartRequested>(_onGetCartRequested);
    on<CreatePaymentRequested>(_onCreatePaymentRequested);
    on<CreateVisitRequested>(_onCreateVisitRequested);
  }

  final UpdateProfileUseCase _updateProfileUseCase;
  final DeleteAccountUseCase _deleteAccountUseCase;
  final GetWishlistUseCase _getWishlistUseCase;
  final CreateAvailabilityUseCase _createAvailabilityUseCase;
  final GetAvailabilityUseCase _getAvailabilityUseCase;
  final CreateCartUseCase _createCartUseCase;
  final GetCartUseCase _getCartUseCase;
  final CreatePaymentUseCase _createPaymentUseCase;
  final CreateVisitUseCase _createVisitUseCase;
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
        // Refresh wishlist and active journeys after success
        add(const WishlistRequested());
        add(const GetAvailabilitiesRequested());
      case Error(failure: final failure):
        emit(
          state.copyWith(
            availabilityStatus: CreateAvailabilityStatus.failure,
            availabilityErrorMessage: failure.message,
          ),
        );
    }
  }

  Future<void> _onGetAvailabilitiesRequested(
    GetAvailabilitiesRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(
      state.copyWith(
        getAvailabilityStatus: GetAvailabilityStatus.loading,
        availabilityErrorMessage: null,
      ),
    );

    final result = await _getAvailabilityUseCase();

    switch (result) {
      case Success(data: final availabilityItems):
        emit(
          state.copyWith(
            getAvailabilityStatus: GetAvailabilityStatus.success,
            availabilityItems: availabilityItems,
            availabilityErrorMessage: null,
          ),
        );
      case Error(failure: final failure):
        emit(
          state.copyWith(
            getAvailabilityStatus: GetAvailabilityStatus.failure,
            availabilityErrorMessage: failure.message,
          ),
        );
    }
  }

  Future<void> _onCreateCartRequested(
    CreateCartRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(
      state.copyWith(
        cartStatus: CreateCartStatus.loading,
        cartErrorMessage: null,
      ),
    );

    final result = await _createCartUseCase(event.landIds);

    switch (result) {
      case Success():
        emit(
          state.copyWith(
            cartStatus: CreateCartStatus.success,
            cartErrorMessage: null,
          ),
        );
      case Error(failure: final failure):
        emit(
          state.copyWith(
            cartStatus: CreateCartStatus.failure,
            cartErrorMessage: failure.message,
          ),
        );
    }
  }

  Future<void> _onGetCartRequested(
    GetCartRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(
      state.copyWith(
        getCartStatus: GetCartStatus.loading,
        cartItemsErrorMessage: null,
      ),
    );

    final result = await _getCartUseCase();

    switch (result) {
      case Success(data: final cartItems):
        emit(
          state.copyWith(
            getCartStatus: GetCartStatus.success,
            cartItems: cartItems,
            cartItemsErrorMessage: null,
          ),
        );
      case Error(failure: final failure):
        emit(
          state.copyWith(
            getCartStatus: GetCartStatus.failure,
            cartItemsErrorMessage: failure.message,
          ),
        );
    }
  }

  Future<void> _onCreatePaymentRequested(
    CreatePaymentRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(
      state.copyWith(
        paymentStatus: CreatePaymentStatus.loading,
        paymentErrorMessage: null,
      ),
    );

    final result = await _createPaymentUseCase(
      landIds: event.landIds,
      amount: event.amount,
      paymentStatus: 'pending',
    );

    switch (result) {
      case Success():
        emit(
          state.copyWith(
            paymentStatus: CreatePaymentStatus.success,
            paymentErrorMessage: null,
          ),
        );
      case Error(failure: final failure):
        emit(
          state.copyWith(
            paymentStatus: CreatePaymentStatus.failure,
            paymentErrorMessage: failure.message,
          ),
        );
    }
  }

  Future<void> _onCreateVisitRequested(
    CreateVisitRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(
      state.copyWith(
        visitStatus: CreateVisitStatus.loading,
        visitErrorMessage: null,
      ),
    );

    final result = await _createVisitUseCase(
      landIds: event.landIds,
      visitDate: event.visitDate,
      time: event.time,
      meetingStatus: 'Scheduled',
    );

    switch (result) {
      case Success():
        emit(
          state.copyWith(
            visitStatus: CreateVisitStatus.success,
            visitErrorMessage: null,
          ),
        );
      case Error(failure: final failure):
        emit(
          state.copyWith(
            visitStatus: CreateVisitStatus.failure,
            visitErrorMessage: failure.message,
          ),
        );
    }
  }
}
