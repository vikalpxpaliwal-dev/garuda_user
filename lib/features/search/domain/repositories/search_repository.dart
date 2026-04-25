import 'package:garuda_user_app/core/utils/result.dart';
import 'package:garuda_user_app/features/search/domain/entities/land_entity.dart';
import 'package:garuda_user_app/features/search/domain/entities/location_entity.dart';

abstract interface class SearchRepository {
  Future<Result<List<LandEntity>>> getLands({Map<String, dynamic>? filters});
  Future<Result<String>> addToWishlist({required List<int> landIds});
  Future<Result<List<StateEntity>>> getLocations();
}
