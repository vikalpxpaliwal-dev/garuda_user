import 'package:equatable/equatable.dart';

enum VerifyOtpStatus { initial, loading, success, failure }

class VerifyOtpState extends Equatable {
  const VerifyOtpState({
    this.status = VerifyOtpStatus.initial,
    this.message,
    this.errorMessage,
  });

  final VerifyOtpStatus status;
  final String? message;
  final String? errorMessage;

  VerifyOtpState copyWith({
    VerifyOtpStatus? status,
    String? message,
    String? errorMessage,
  }) {
    return VerifyOtpState(
      status: status ?? this.status,
      message: message ?? this.message,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, message, errorMessage];
}
