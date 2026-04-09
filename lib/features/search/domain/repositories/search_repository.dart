import 'package:garuda_user_app/core/utils/result.dart';
import 'package:garuda_user_app/features/search/domain/entities/land_entity.dart';

abstract interface class SearchRepository {
  Future<Result<List<LandEntity>>> getLands();
}
