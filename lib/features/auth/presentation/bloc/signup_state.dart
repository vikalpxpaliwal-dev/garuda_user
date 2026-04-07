import 'package:equatable/equatable.dart';
import 'package:garuda_user_app/features/auth/domain/entities/user_entity.dart';

enum SignupStatus { initial, loading, success, failure }

class SignupState extends Equatable {
  const SignupState({
    this.status = SignupStatus.initial,
    this.user,
    this.errorMessage,
  });

  final SignupStatus status;
  final UserEntity? user;
  final String? errorMessage;

  SignupState copyWith({
    SignupStatus? status,
    UserEntity? user,
    String? errorMessage,
  }) {
    return SignupState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, user, errorMessage];
}
