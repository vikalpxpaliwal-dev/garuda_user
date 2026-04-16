import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garuda_user_app/core/utils/result.dart';
import 'package:garuda_user_app/features/auth/domain/usecases/delete_account_usecase.dart';
import 'package:garuda_user_app/features/auth/domain/usecases/update_profile_usecase.dart';
import 'package:garuda_user_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:garuda_user_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:garuda_user_app/features/profile/domain/usecases/create_availability_usecase.dart';
import 'package:garuda_user_app/features/profile/domain/usecases/create_cart_usecase.dart';
import 'package:garuda_user_app/features/profile/domain/usecases/create_final_usecase.dart';
import 'package:garuda_user_app/features/profile/domain/usecases/create_payment_usecase.dart';
import 'package:garuda_user_app/features/profile/domain/usecases/create_shortlist_usecase.dart';
import 'package:garuda_user_app/features/profile/domain/usecases/create_visit_usecase.dart';
import 'package:garuda_user_app/features/profile/domain/usecases/delete_final_usecase.dart';
import 'package:garuda_user_app/features/profile/domain/usecases/delete_shortlist_usecase.dart';
import 'package:garuda_user_app/features/profile/domain/usecases/get_availability_usecase.dart';
import 'package:garuda_user_app/features/profile/domain/usecases/get_cart_usecase.dart';
import 'package:garuda_user_app/features/profile/domain/usecases/get_finals_usecase.dart';
import 'package:garuda_user_app/features/profile/domain/usecases/get_shortlists_usecase.dart';
import 'package:garuda_user_app/features/profile/domain/usecases/get_visits_usecase.dart';
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
    required GetShortlistsUseCase getShortlistsUseCase,
    required GetFinalsUseCase getFinalsUseCase,
    required CreateShortlistUseCase createShortlistUseCase,
    required DeleteShortlistUseCase deleteShortlistUseCase,
    required CreateFinalUseCase createFinalUseCase,
    required DeleteFinalUseCase deleteFinalUseCase,
    required CreateVisitUseCase createVisitUseCase,
    required GetVisitsUseCase getVisitsUseCase,
    required AuthBloc authBloc,
  })  : _updateProfileUseCase = updateProfileUseCase,
        _deleteAccountUseCase = deleteAccountUseCase,
        _getWishlistUseCase = getWishlistUseCase,
        _createAvailabilityUseCase = createAvailabilityUseCase,
        _getAvailabilityUseCase = getAvailabilityUseCase,
        _createCartUseCase = createCartUseCase,
        _getCartUseCase = getCartUseCase,
        _createPaymentUseCase = createPaymentUseCase,
        _getShortlistsUseCase = getShortlistsUseCase,
        _getFinalsUseCase = getFinalsUseCase,
        _createShortlistUseCase = createShortlistUseCase,
        _deleteShortlistUseCase = deleteShortlistUseCase,
        _createFinalUseCase = createFinalUseCase,
        _deleteFinalUseCase = deleteFinalUseCase,
        _createVisitUseCase = createVisitUseCase,
        _getVisitsUseCase = getVisitsUseCase,
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
    on<GetShortlistsRequested>(_onGetShortlistsRequested);
    on<GetFinalsRequested>(_onGetFinalsRequested);
    on<CreateShortlistRequested>(_onCreateShortlistRequested);
    on<DeleteShortlistRequested>(_onDeleteShortlistRequested);
    on<CreateFinalRequested>(_onCreateFinalRequested);
    on<DeleteFinalRequested>(_onDeleteFinalRequested);
    on<CreateVisitRequested>(_onCreateVisitRequested);
    on<GetVisitsRequested>(_onGetVisitsRequested);
  }

  final UpdateProfileUseCase _updateProfileUseCase;
  final DeleteAccountUseCase _deleteAccountUseCase;
  final GetWishlistUseCase _getWishlistUseCase;
  final CreateAvailabilityUseCase _createAvailabilityUseCase;
  final GetAvailabilityUseCase _getAvailabilityUseCase;
  final CreateCartUseCase _createCartUseCase;
  final GetCartUseCase _getCartUseCase;
  final CreatePaymentUseCase _createPaymentUseCase;
  final GetShortlistsUseCase _getShortlistsUseCase;
  final GetFinalsUseCase _getFinalsUseCase;
  final CreateShortlistUseCase _createShortlistUseCase;
  final DeleteShortlistUseCase _deleteShortlistUseCase;
  final CreateFinalUseCase _createFinalUseCase;
  final DeleteFinalUseCase _deleteFinalUseCase;
  final CreateVisitUseCase _createVisitUseCase;
  final GetVisitsUseCase _getVisitsUseCase;
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

  Future<void> _onCreateShortlistRequested(
    CreateShortlistRequested event,
    Emitter<ProfileState> emit,
  ) async {
    final isAlreadyLoading = state.shortlistStatus == CreateShortlistStatus.loading &&
        state.activeShortlistLandId == event.landId;
    if (isAlreadyLoading) {
      return;
    }

    emit(
      state.copyWith(
        shortlistStatus: CreateShortlistStatus.loading,
        shortlistMessage: null,
        activeShortlistLandId: event.landId,
      ),
    );

    final result = await _createShortlistUseCase(landId: event.landId);

    switch (result) {
      case Success(data: final message):
        final updatedShortlistedIds = <int>{
          ...state.shortlistedLandIds,
          event.landId,
        }.toList();
        emit(
          state.copyWith(
            shortlistStatus: CreateShortlistStatus.success,
            shortlistMessage: message,
            activeShortlistLandId: event.landId,
            shortlistedLandIds: updatedShortlistedIds,
          ),
        );
        add(const GetShortlistsRequested());
      case Error(failure: final failure):
        emit(
          state.copyWith(
            shortlistStatus: CreateShortlistStatus.failure,
            shortlistMessage: failure.message,
            activeShortlistLandId: event.landId,
          ),
        );
    }
  }

  Future<void> _onDeleteShortlistRequested(
    DeleteShortlistRequested event,
    Emitter<ProfileState> emit,
  ) async {
    final isAlreadyLoading =
        state.deleteShortlistStatus == DeleteShortlistStatus.loading &&
        state.activeDeleteShortlistLandId == event.landId;
    if (isAlreadyLoading) {
      return;
    }

    emit(
      state.copyWith(
        deleteShortlistStatus: DeleteShortlistStatus.loading,
        deleteShortlistMessage: null,
        activeDeleteShortlistLandId: event.landId,
      ),
    );

    final result = await _deleteShortlistUseCase(landId: event.landId);

    switch (result) {
      case Success(data: final message):
        final updatedShortlistedIds = state.shortlistedLandIds
            .where((id) => id != event.landId)
            .toList();
        emit(
          state.copyWith(
            deleteShortlistStatus: DeleteShortlistStatus.success,
            deleteShortlistMessage: message,
            activeDeleteShortlistLandId: event.landId,
            shortlistedLandIds: updatedShortlistedIds,
            shortlistItems: state.shortlistItems
                .where((item) => item.landId != event.landId)
                .toList(),
            finalizedLandIds: state.finalizedLandIds
                .where((id) => id != event.landId)
                .toList(),
          ),
        );
      case Error(failure: final failure):
        emit(
          state.copyWith(
            deleteShortlistStatus: DeleteShortlistStatus.failure,
            deleteShortlistMessage: failure.message,
            activeDeleteShortlistLandId: event.landId,
          ),
        );
    }
  }

  Future<void> _onGetShortlistsRequested(
    GetShortlistsRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(
      state.copyWith(
        getShortlistsStatus: GetShortlistsStatus.loading,
        shortlistItemsErrorMessage: null,
      ),
    );

    final result = await _getShortlistsUseCase();

    switch (result) {
      case Success(data: final shortlistItems):
        emit(
          state.copyWith(
            getShortlistsStatus: GetShortlistsStatus.success,
            shortlistItems: shortlistItems,
            shortlistedLandIds: shortlistItems.map((item) => item.landId).toList(),
            shortlistItemsErrorMessage: null,
          ),
        );
      case Error(failure: final failure):
        emit(
          state.copyWith(
            getShortlistsStatus: GetShortlistsStatus.failure,
            shortlistItemsErrorMessage: failure.message,
          ),
        );
    }
  }

  Future<void> _onGetFinalsRequested(
    GetFinalsRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(
      state.copyWith(
        getFinalsStatus: GetFinalsStatus.loading,
        finalItemsErrorMessage: null,
      ),
    );

    final result = await _getFinalsUseCase();

    switch (result) {
      case Success(data: final finalItems):
        emit(
          state.copyWith(
            getFinalsStatus: GetFinalsStatus.success,
            finalItems: finalItems,
            finalizedLandIds: finalItems.map((item) => item.landId).toList(),
            finalItemsErrorMessage: null,
          ),
        );
      case Error(failure: final failure):
        emit(
          state.copyWith(
            getFinalsStatus: GetFinalsStatus.failure,
            finalItemsErrorMessage: failure.message,
          ),
        );
    }
  }

  Future<void> _onCreateFinalRequested(
    CreateFinalRequested event,
    Emitter<ProfileState> emit,
  ) async {
    final isAlreadyLoading = state.createFinalStatus == CreateFinalStatus.loading &&
        state.activeFinalLandId == event.landId;
    if (isAlreadyLoading) {
      return;
    }

    emit(
      state.copyWith(
        createFinalStatus: CreateFinalStatus.loading,
        finalMessage: null,
        activeFinalLandId: event.landId,
      ),
    );

    final result = await _createFinalUseCase(landId: event.landId);

    switch (result) {
      case Success(data: final message):
        final updatedFinalizedIds = <int>{...state.finalizedLandIds, event.landId}.toList();
        emit(
          state.copyWith(
            createFinalStatus: CreateFinalStatus.success,
            finalMessage: message,
            activeFinalLandId: event.landId,
            finalizedLandIds: updatedFinalizedIds,
          ),
        );
        add(const GetFinalsRequested());
      case Error(failure: final failure):
        emit(
          state.copyWith(
            createFinalStatus: CreateFinalStatus.failure,
            finalMessage: failure.message,
            activeFinalLandId: event.landId,
          ),
        );
    }
  }

  Future<void> _onDeleteFinalRequested(
    DeleteFinalRequested event,
    Emitter<ProfileState> emit,
  ) async {
    final isAlreadyLoading = state.deleteFinalStatus == DeleteFinalStatus.loading &&
        state.activeDeleteFinalLandId == event.landId;
    if (isAlreadyLoading) {
      return;
    }

    emit(
      state.copyWith(
        deleteFinalStatus: DeleteFinalStatus.loading,
        deleteFinalMessage: null,
        activeDeleteFinalLandId: event.landId,
      ),
    );

    final result = await _deleteFinalUseCase(landId: event.landId);

    switch (result) {
      case Success(data: final message):
        emit(
          state.copyWith(
            deleteFinalStatus: DeleteFinalStatus.success,
            deleteFinalMessage: message,
            activeDeleteFinalLandId: event.landId,
            finalItems: state.finalItems
                .where((item) => item.landId != event.landId)
                .toList(),
            finalizedLandIds: state.finalizedLandIds
                .where((id) => id != event.landId)
                .toList(),
          ),
        );
      case Error(failure: final failure):
        emit(
          state.copyWith(
            deleteFinalStatus: DeleteFinalStatus.failure,
            deleteFinalMessage: failure.message,
            activeDeleteFinalLandId: event.landId,
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
        add(const GetVisitsRequested());
      case Error(failure: final failure):
        emit(
          state.copyWith(
            visitStatus: CreateVisitStatus.failure,
            visitErrorMessage: failure.message,
          ),
        );
    }
  }

  Future<void> _onGetVisitsRequested(
    GetVisitsRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(
      state.copyWith(
        getVisitsStatus: GetVisitsStatus.loading,
        visitItemsErrorMessage: null,
      ),
    );

    final result = await _getVisitsUseCase();

    switch (result) {
      case Success(data: final visitItems):
        emit(
          state.copyWith(
            getVisitsStatus: GetVisitsStatus.success,
            visitItems: visitItems,
            visitItemsErrorMessage: null,
          ),
        );
      case Error(failure: final failure):
        emit(
          state.copyWith(
            getVisitsStatus: GetVisitsStatus.failure,
            visitItemsErrorMessage: failure.message,
          ),
        );
    }
  }
}
