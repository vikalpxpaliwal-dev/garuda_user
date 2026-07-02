import 'package:garuda_user_app/core/data/repository_executor.dart';
import 'package:garuda_user_app/core/utils/result.dart';
import 'package:garuda_user_app/features/home/data/config/home_data_config.dart';
import 'package:garuda_user_app/features/home/data/datasources/demo_home_data_source.dart';
import 'package:garuda_user_app/features/home/data/datasources/home_remote_data_source.dart';
import 'package:garuda_user_app/features/home/domain/entities/home_dashboard.dart';
import 'package:garuda_user_app/features/home/domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  const HomeRepositoryImpl({
    required DemoHomeDataSource demoDataSource,
    required HomeRemoteDataSource remoteDataSource,
  })  : _demoDataSource = demoDataSource,
        _remoteDataSource = remoteDataSource;

  final DemoHomeDataSource _demoDataSource;
  final HomeRemoteDataSource _remoteDataSource;

  @override
  Future<Result<HomeDashboard>> getHomeDashboard() {
    return RepositoryExecutor.runSafely(
      () => HomeDataConfig.useDemoHome
          ? _demoDataSource.getHomeDashboard()
          : _remoteDataSource.getHomeDashboard(),
      policy: RepositoryErrorPolicy.home,
    );
  }
}
