import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garuda_user_app/core/utils/result.dart';
import 'package:garuda_user_app/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:garuda_user_app/features/auth/presentation/bloc/verify_otp_event.dart';
import 'package:garuda_user_app/features/auth/presentation/bloc/verify_otp_state.dart';

class VerifyOtpBloc extends Bloc<VerifyOtpEvent, VerifyOtpState> {
  VerifyOtpBloc({
    required VerifyOtpUseCase verifyOtpUseCase,
  })  : _verifyOtpUseCase = verifyOtpUseCase,
        super(const VerifyOtpState()) {
    on<VerifyOtpRequested>(_onVerifyOtpRequested);
  }

  final VerifyOtpUseCase _verifyOtpUseCase;

  Future<void> _onVerifyOtpRequested(
    VerifyOtpRequested event,
    Emitter<VerifyOtpState> emit,
  ) async {
    emit(state.copyWith(status: VerifyOtpStatus.loading));

    final result = await _verifyOtpUseCase(
      email: event.email,
      otp: event.otp,
    );

    switch (result) {
      case Success(data: final message):
        emit(state.copyWith(
          status: VerifyOtpStatus.success,
          message: message,
        ));
      case Error(failure: final failure):
        emit(state.copyWith(
          status: VerifyOtpStatus.failure,
          errorMessage: failure.message,
        ));
    }
  }
}
