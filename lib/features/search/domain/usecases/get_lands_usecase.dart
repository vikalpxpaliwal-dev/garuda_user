import 'package:garuda_user_app/core/utils/result.dart';
import 'package:garuda_user_app/features/search/domain/entities/land_entity.dart';
import 'package:garuda_user_app/features/search/domain/repositories/search_repository.dart';

class GetLandsUseCase {
  final SearchRepository _repository;

  GetLandsUseCase(this._repository);

  Future<Result<List<LandEntity>>> call({Map<String, dynamic>? filters}) {
    return _repository.getLands(filters: filters);
  }
}
