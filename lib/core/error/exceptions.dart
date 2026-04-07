class AppException implements Exception {
  const AppException({required this.message, this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() =>
      'AppException(message: $message, statusCode: $statusCode)';
}

final class NetworkException extends AppException {
  const NetworkException({required super.message, super.statusCode});
}

final class ServerException extends AppException {
  const ServerException({required super.message, super.statusCode});
}

final class CacheException extends AppException {
  const CacheException({required super.message, super.statusCode});
}
