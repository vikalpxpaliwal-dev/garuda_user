import 'package:garuda_user_app/core/data/repository_executor.dart';
import 'package:garuda_user_app/core/error/exceptions.dart';
import 'package:garuda_user_app/core/error/failures.dart';
import 'package:garuda_user_app/core/utils/result.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RepositoryExecutor', () {
    test('maps NetworkException to NetworkFailure with standard policy', () async {
      final result = await RepositoryExecutor.runSafely<void>(() async {
        throw const NetworkException(message: 'offline', statusCode: 503);
      });

      expect(result, isA<Error<void>>());
      final failure = (result as Error<void>).failure;
      expect(failure, isA<NetworkFailure>());
      expect(failure.message, 'offline');
      expect(failure.statusCode, 503);
    });

    test('maps ServerException to ServerFailure with standard policy', () async {
      final result = await RepositoryExecutor.runSafely<void>(() async {
        throw const ServerException(message: 'bad request', statusCode: 400);
      });

      expect(result, isA<Error<void>>());
      final failure = (result as Error<void>).failure;
      expect(failure, isA<ServerFailure>());
      expect(failure.message, 'bad request');
    });

    test('maps every AppException to ServerFailure with serverOnly policy', () async {
      final result = await RepositoryExecutor.runSafely<void>(
        () async {
          throw const NetworkException(message: 'offline');
        },
        policy: RepositoryErrorPolicy.serverOnly,
      );

      expect(result, isA<Error<void>>());
      expect((result as Error<void>).failure, isA<ServerFailure>());
    });

    test('maps CacheException with home policy', () async {
      final result = await RepositoryExecutor.runSafely<void>(
        () async {
          throw const CacheException(message: 'cache miss');
        },
        policy: RepositoryErrorPolicy.home,
      );

      expect(result, isA<Error<void>>());
      expect((result as Error<void>).failure, isA<CacheFailure>());
    });

    test('returns Success when action succeeds', () async {
      final result = await RepositoryExecutor.runSafely(() async => 'ok');

      expect(result, isA<Success<String>>());
      expect((result as Success<String>).data, 'ok');
    });
  });
}
