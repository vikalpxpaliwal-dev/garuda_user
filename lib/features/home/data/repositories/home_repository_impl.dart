import 'package:garuda_user_app/core/constants/app_strings.dart';
import 'package:garuda_user_app/core/error/exceptions.dart';
import 'package:garuda_user_app/core/error/failures.dart';
import 'package:garuda_user_app/core/utils/result.dart';
import 'package:garuda_user_app/features/home/data/datasources/home_local_data_source.dart';
import 'package:garuda_user_app/features/home/domain/entities/home_dashboard.dart';
import 'package:garuda_user_app/features/home/domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  const HomeRepositoryImpl({required HomeLocalDataSource localDataSource})
    : _localDataSource = localDataSource;

  final HomeLocalDataSource _localDataSource;

  @override
  Future<Result<HomeDashboard>> getHomeDashboard() async {
    try {
      final dashboard = await _localDataSource.getHomeDashboard();
      return Success<HomeDashboard>(dashboard);
    } on NetworkException catch (exception) {
      return Error<HomeDashboard>(
        NetworkFailure(
          message: exception.message,
          statusCode: exception.statusCode,
        ),
      );
    } on ServerException catch (exception) {
      return Error<HomeDashboard>(
        ServerFailure(
          message: exception.message,
          statusCode: exception.statusCode,
        ),
      );
    } on CacheException catch (exception) {
      return Error<HomeDashboard>(
        CacheFailure(
          message: exception.message,
          statusCode: exception.statusCode,
        ),
      );
    } catch (_) {
      return const Error<HomeDashboard>(
        CacheFailure(message: AppStrings.unexpectedError),
      );
    }
  }
}
