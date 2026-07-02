import 'package:equatable/equatable.dart';
import 'package:garuda_user_app/features/auth/domain/entities/signup_credentials.dart';

sealed class SignupEvent extends Equatable {
  const SignupEvent();

  @override
  List<Object?> get props => [];
}

class SignupRequested extends SignupEvent {
  const SignupRequested(this.credentials);

  final SignupCredentials credentials;

  @override
  List<Object?> get props => [credentials];
}
