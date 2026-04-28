import 'package:equatable/equatable.dart';

sealed class ForgotPasswordEvent extends Equatable {
  const ForgotPasswordEvent();

  @override
  List<Object?> get props => [];
}

class ForgotPasswordRequested extends ForgotPasswordEvent {
  const ForgotPasswordRequested(this.email);

  final String email;

  @override
  List<Object?> get props => [email];
}
