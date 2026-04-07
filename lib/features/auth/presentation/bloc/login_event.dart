import 'package:equatable/equatable.dart';
import 'package:garuda_user_app/features/auth/data/models/login_request_model.dart';

sealed class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

class LoginRequested extends LoginEvent {
  const LoginRequested(this.request);

  final LoginRequestModel request;

  @override
  List<Object?> get props => [request];
}
