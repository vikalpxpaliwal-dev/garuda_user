import 'package:garuda_user_app/core/constants/app_strings.dart';
import 'package:garuda_user_app/core/error/exceptions.dart';
import 'package:garuda_user_app/core/error/failures.dart';
import 'package:garuda_user_app/core/utils/result.dart';

enum RepositoryErrorPolicy {
  /// Maps [NetworkException] to [NetworkFailure]; other [AppException] to [ServerFailure].
  standard,

  /// Maps every [AppException] to [ServerFailure].
  serverOnly,

  /// Maps [NetworkException], [ServerException], and [CacheException] to matching failures.
  home,
}

class RepositoryExecutor {
  const RepositoryExecutor._();

  static Future<Result<T>> runSafely<T>(
    Future<T> Function() action, {
    RepositoryErrorPolicy policy = RepositoryErrorPolicy.standard,
  }) async {
    try {
      final data = await action();
      return Success(data);
    } on AppException catch (exception) {
      return Error(_mapAppException(exception, policy));
    } catch (error) {
      return Error(_mapUnknownError(error, policy));
    }
  }

  static Failure _mapAppException(
    AppException exception,
    RepositoryErrorPolicy policy,
  ) {
    switch (policy) {
      case RepositoryErrorPolicy.serverOnly:
        return ServerFailure(
          message: exception.message,
          statusCode: exception.statusCode,
        );
      case RepositoryErrorPolicy.home:
        if (exception is NetworkException) {
          return NetworkFailure(
            message: exception.message,
            statusCode: exception.statusCode,
          );
        }
        if (exception is ServerException) {
          return ServerFailure(
            message: exception.message,
            statusCode: exception.statusCode,
          );
        }
        if (exception is CacheException) {
          return CacheFailure(
            message: exception.message,
            statusCode: exception.statusCode,
          );
        }
        return ServerFailure(
          message: exception.message,
          statusCode: exception.statusCode,
        );
      case RepositoryErrorPolicy.standard:
        if (exception is NetworkException) {
          return NetworkFailure(
            message: exception.message,
            statusCode: exception.statusCode,
          );
        }
        return ServerFailure(
          message: exception.message,
          statusCode: exception.statusCode,
        );
    }
  }

  static Failure _mapUnknownError(
    Object error,
    RepositoryErrorPolicy policy,
  ) {
    return switch (policy) {
      RepositoryErrorPolicy.home => const CacheFailure(
          message: AppStrings.unexpectedError,
        ),
      RepositoryErrorPolicy.standard ||
      RepositoryErrorPolicy.serverOnly =>
        ServerFailure(message: error.toString()),
    };
  }
}
