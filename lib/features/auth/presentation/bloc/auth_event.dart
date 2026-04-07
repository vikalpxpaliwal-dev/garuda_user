import 'package:equatable/equatable.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AppStarted extends AuthEvent {}

class UserLoggedIn extends AuthEvent {}

class UserLoggedOut extends AuthEvent {}
