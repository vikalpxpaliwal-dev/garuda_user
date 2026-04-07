import 'package:equatable/equatable.dart';
import 'package:garuda_user_app/features/auth/domain/entities/user_entity.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AppStarted extends AuthEvent {}

class UserLoggedIn extends AuthEvent {
  const UserLoggedIn(this.user);

  final UserEntity user;

  @override
  List<Object?> get props => [user];
}

class UserLoggedOut extends AuthEvent {}
