import 'package:equatable/equatable.dart';
import 'package:garuda_user_app/features/auth/data/models/signup_request_model.dart';

sealed class SignupEvent extends Equatable {
  const SignupEvent();

  @override
  List<Object?> get props => [];
}

class SignupRequested extends SignupEvent {
  const SignupRequested(this.request);

  final SignupRequestModel request;

  @override
  List<Object?> get props => [request];
}
