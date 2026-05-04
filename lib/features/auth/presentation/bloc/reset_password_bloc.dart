import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garuda_user_app/core/utils/result.dart';
import 'package:garuda_user_app/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:garuda_user_app/features/auth/presentation/bloc/reset_password_event.dart';
import 'package:garuda_user_app/features/auth/presentation/bloc/reset_password_state.dart';

class ResetPasswordBloc extends Bloc<ResetPasswordEvent, ResetPasswordState> {
  ResetPasswordBloc({
    required ResetPasswordUseCase resetPasswordUseCase,
  })  : _resetPasswordUseCase = resetPasswordUseCase,
        super(const ResetPasswordState()) {
    on<ResetPasswordRequested>(_onResetPasswordRequested);
  }

  final ResetPasswordUseCase _resetPasswordUseCase;

  Future<void> _onResetPasswordRequested(
    ResetPasswordRequested event,
    Emitter<ResetPasswordState> emit,
  ) async {
    emit(state.copyWith(status: ResetPasswordStatus.loading));

    final result = await _resetPasswordUseCase(
      email: event.email,
      otp: event.otp,
      newPassword: event.newPassword,
    );

    switch (result) {
      case Success(data: final message):
        emit(state.copyWith(
          status: ResetPasswordStatus.success,
          message: message,
        ));
      case Error(failure: final failure):
        emit(state.copyWith(
          status: ResetPasswordStatus.failure,
          errorMessage: failure.message,
        ));
    }
  }
}
