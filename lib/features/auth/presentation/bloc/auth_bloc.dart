import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garuda_user_app/core/utils/result.dart';
import 'package:garuda_user_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:garuda_user_app/features/auth/domain/services/auth_session_controller.dart';
import 'package:garuda_user_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:garuda_user_app/features/auth/presentation/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required AuthRepository authRepository,
    required AuthSessionController sessionController,
  })  : _authRepository = authRepository,
        _sessionController = sessionController,
        super(const AuthState()) {
    on<AppStarted>(_onAppStarted);
    on<UserLoggedIn>(_onUserLoggedIn);
    on<UserLoggedOut>(_onUserLoggedOut);
    on<SessionExpired>(_onSessionExpired);

    _sessionSubscription = _sessionController.onSessionExpired.listen((_) {
      add(const SessionExpired());
    });
  }

  final AuthRepository _authRepository;
  final AuthSessionController _sessionController;
  StreamSubscription<void>? _sessionSubscription;

  Future<void> _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    final result = await _authRepository.refreshToken();

    if (result is Success<String>) {
      final user = await _authRepository.getUser();
      emit(AuthState(status: AuthStatus.authenticated, user: user));
    } else {
      emit(const AuthState(status: AuthStatus.unauthenticated));
    }
  }

  void _onUserLoggedIn(UserLoggedIn event, Emitter<AuthState> emit) {
    emit(AuthState(status: AuthStatus.authenticated, user: event.user));
  }

  Future<void> _onUserLoggedOut(
    UserLoggedOut event,
    Emitter<AuthState> emit,
  ) async {
    await _authRepository.logout();
    emit(const AuthState(status: AuthStatus.unauthenticated));
  }

  void _onSessionExpired(SessionExpired event, Emitter<AuthState> emit) {
    emit(const AuthState(status: AuthStatus.unauthenticated));
  }

  @override
  Future<void> close() {
    _sessionSubscription?.cancel();
    return super.close();
  }
}
