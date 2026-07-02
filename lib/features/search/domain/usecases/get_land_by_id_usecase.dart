import 'package:garuda_user_app/core/utils/result.dart';
import 'package:garuda_user_app/features/search/domain/entities/land_entity.dart';
import 'package:garuda_user_app/features/search/domain/repositories/search_repository.dart';

class GetLandByIdUseCase {
  const GetLandByIdUseCase(this._repository);

  final SearchRepository _repository;

  Future<Result<LandEntity?>> call(int landId) async {
    final cached = await _repository.getLands(
      filters: <String, dynamic>{'land_id': landId},
    );

    return switch (cached) {
      Success(data: final lands) => Success(_matchLand(lands, landId)),
      Error(failure: final failure) => Error(failure),
    };
  }

  LandEntity? _matchLand(List<LandEntity> lands, int landId) {
    for (final land in lands) {
      if (land.id == landId) {
        return land;
      }
    }
    return lands.length == 1 ? lands.first : null;
  }
}
