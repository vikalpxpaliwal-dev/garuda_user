import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garuda_user_app/core/utils/result.dart';
import 'package:garuda_user_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:garuda_user_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:garuda_user_app/features/auth/domain/usecases/delete_account_usecase.dart';
import 'package:garuda_user_app/features/auth/domain/usecases/update_profile_usecase.dart';
import 'package:garuda_user_app/features/profile/presentation/bloc/profile_event.dart';
import 'package:garuda_user_app/features/profile/presentation/bloc/profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc({
    required UpdateProfileUseCase updateProfileUseCase,
    required DeleteAccountUseCase deleteAccountUseCase,
    required AuthBloc authBloc,
  })  : _updateProfileUseCase = updateProfileUseCase,
        _deleteAccountUseCase = deleteAccountUseCase,
        _authBloc = authBloc,
        super(const ProfileState()) {
    on<UpdateProfileRequested>(_onUpdateProfileRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<DeleteAccountRequested>(_onDeleteAccountRequested);
  }

  final UpdateProfileUseCase _updateProfileUseCase;
  final DeleteAccountUseCase _deleteAccountUseCase;
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
}
