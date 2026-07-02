import 'package:equatable/equatable.dart';
import 'package:garuda_user_app/features/auth/domain/entities/login_credentials.dart';

sealed class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

class LoginRequested extends LoginEvent {
  const LoginRequested(this.credentials);

  final LoginCredentials credentials;

  @override
  List<Object?> get props => [credentials];
}
