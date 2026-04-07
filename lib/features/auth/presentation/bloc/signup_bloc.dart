import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garuda_user_app/core/constants/app_strings.dart';
import 'package:garuda_user_app/core/utils/result.dart';
import 'package:garuda_user_app/features/auth/domain/entities/user_entity.dart';
import 'package:garuda_user_app/features/auth/domain/usecases/signup_usecase.dart';
import 'package:garuda_user_app/features/auth/presentation/bloc/signup_event.dart';
import 'package:garuda_user_app/features/auth/presentation/bloc/signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  SignupBloc({required SignupUseCase signupUseCase})
      : _signupUseCase = signupUseCase,
        super(const SignupState()) {
    on<SignupRequested>(_onSignupRequested);
  }

  final SignupUseCase _signupUseCase;

  Future<void> _onSignupRequested(
    SignupRequested event,
    Emitter<SignupState> emit,
  ) async {
    emit(state.copyWith(status: SignupStatus.loading, errorMessage: null));

    final result = await _signupUseCase(event.request);

    switch (result) {
      case Success<UserEntity>(:final data):
        emit(
          state.copyWith(
            status: SignupStatus.success,
            user: data,
            errorMessage: null,
          ),
        );
      case Error<UserEntity>(:final failure):
        emit(
          state.copyWith(
            status: SignupStatus.failure,
            errorMessage: failure.message.isEmpty
                ? AppStrings.unexpectedError
                : failure.message,
          ),
        );
    }
  }
}
