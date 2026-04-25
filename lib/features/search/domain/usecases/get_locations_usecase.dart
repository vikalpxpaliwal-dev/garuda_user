import 'package:garuda_user_app/core/utils/result.dart';
import 'package:garuda_user_app/features/search/domain/entities/location_entity.dart';
import 'package:garuda_user_app/features/search/domain/repositories/search_repository.dart';

class GetLocationsUseCase {
  final SearchRepository _repository;

  GetLocationsUseCase(this._repository);

  Future<Result<List<StateEntity>>> call() => _repository.getLocations();
}
