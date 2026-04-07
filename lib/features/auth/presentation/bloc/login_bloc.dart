import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garuda_user_app/core/constants/app_strings.dart';
import 'package:garuda_user_app/core/utils/result.dart';
import 'package:garuda_user_app/features/auth/domain/entities/user_entity.dart';
import 'package:garuda_user_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:garuda_user_app/features/auth/presentation/bloc/login_event.dart';
import 'package:garuda_user_app/features/auth/presentation/bloc/login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({required LoginUseCase loginUseCase})
      : _loginUseCase = loginUseCase,
        super(const LoginState()) {
    on<LoginRequested>(_onLoginRequested);
  }

  final LoginUseCase _loginUseCase;

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(status: LoginStatus.loading, errorMessage: null));

    final result = await _loginUseCase(event.request);

    switch (result) {
      case Success<UserEntity>(:final data):
        emit(
          state.copyWith(
            status: LoginStatus.success,
            user: data,
            errorMessage: null,
          ),
        );
      case Error<UserEntity>(:final failure):
        emit(
          state.copyWith(
            status: LoginStatus.failure,
            errorMessage: failure.message.isEmpty
                ? AppStrings.unexpectedError
                : failure.message,
          ),
        );
    }
  }
}
