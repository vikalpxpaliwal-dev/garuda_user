import 'package:equatable/equatable.dart';

enum ResetPasswordStatus { initial, loading, success, failure }

class ResetPasswordState extends Equatable {
  const ResetPasswordState({
    this.status = ResetPasswordStatus.initial,
    this.message,
    this.errorMessage,
  });

  final ResetPasswordStatus status;
  final String? message;
  final String? errorMessage;

  ResetPasswordState copyWith({
    ResetPasswordStatus? status,
    String? message,
    String? errorMessage,
  }) {
    return ResetPasswordState(
      status: status ?? this.status,
      message: message ?? this.message,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, message, errorMessage];
}
