import 'package:equatable/equatable.dart';

sealed class Failure extends Equatable {
  const Failure({required this.message, this.statusCode});

  final String message;
  final int? statusCode;

  @override
  List<Object?> get props => <Object?>[message, statusCode];
}

final class NetworkFailure extends Failure {
  const NetworkFailure({required super.message, super.statusCode});
}

final class ServerFailure extends Failure {
  const ServerFailure({required super.message, super.statusCode});
}

final class CacheFailure extends Failure {
  const CacheFailure({required super.message, super.statusCode});
}
