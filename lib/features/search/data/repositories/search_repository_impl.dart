import 'package:garuda_user_app/core/data/repository_executor.dart';
import 'package:garuda_user_app/core/utils/result.dart';
import 'package:garuda_user_app/features/search/data/datasources/search_remote_data_source.dart';
import 'package:garuda_user_app/features/search/domain/entities/land_entity.dart';
import 'package:garuda_user_app/features/search/domain/entities/location_entity.dart';
import 'package:garuda_user_app/features/search/domain/repositories/search_repository.dart';

class SearchRepositoryImpl implements SearchRepository {
  SearchRepositoryImpl(this._remoteDataSource);

  final SearchRemoteDataSource _remoteDataSource;

  @override
  Future<Result<List<LandEntity>>> getLands({
    Map<String, dynamic>? filters,
  }) {
    return RepositoryExecutor.runSafely(() async {
      final landModels = await _remoteDataSource.getLands(filters: filters);
      return landModels.map((model) => model.toEntity()).toList();
    });
  }

  @override
  Future<Result<List<StateEntity>>> getLocations() {
    return RepositoryExecutor.runSafely(() async {
      final stateModels = await _remoteDataSource.getLocations();
      return stateModels.map((model) => model.toEntity()).toList();
    });
  }
}
