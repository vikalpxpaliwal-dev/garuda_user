import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garuda_user_app/core/utils/result.dart';
import 'package:garuda_user_app/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:garuda_user_app/features/auth/presentation/bloc/forgot_password_event.dart';
import 'package:garuda_user_app/features/auth/presentation/bloc/forgot_password_state.dart';

class ForgotPasswordBloc extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  ForgotPasswordBloc({
    required ForgotPasswordUseCase forgotPasswordUseCase,
  })  : _forgotPasswordUseCase = forgotPasswordUseCase,
        super(const ForgotPasswordState()) {
    on<ForgotPasswordRequested>(_onForgotPasswordRequested);
  }

  final ForgotPasswordUseCase _forgotPasswordUseCase;

  Future<void> _onForgotPasswordRequested(
    ForgotPasswordRequested event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    emit(state.copyWith(status: ForgotPasswordStatus.loading));

    final result = await _forgotPasswordUseCase(event.email);

    switch (result) {
      case Success(data: final message):
        emit(state.copyWith(
          status: ForgotPasswordStatus.success,
          message: message,
        ));
      case Error(failure: final failure):
        emit(state.copyWith(
          status: ForgotPasswordStatus.failure,
          errorMessage: failure.message,
        ));
    }
  }
}
