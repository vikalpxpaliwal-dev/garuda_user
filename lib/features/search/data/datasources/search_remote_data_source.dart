import 'package:garuda_user_app/core/network/api_service.dart';
import 'package:garuda_user_app/features/search/data/models/land_model.dart';
import 'package:garuda_user_app/features/search/data/models/location_model.dart';

abstract interface class SearchRemoteDataSource {
  Future<List<LandModel>> getLands({Map<String, dynamic>? filters});
  Future<String> addToWishlist({required List<int> landIds});
  Future<List<StateModel>> getLocations();
}

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  final ApiService _apiService;

  SearchRemoteDataSourceImpl(this._apiService);

  @override
  Future<List<LandModel>> getLands({Map<String, dynamic>? filters}) async {
    final response = await _apiService.get('/buyer/land', queryParameters: filters);

    if (response.data != null && response.data['success'] == true) {
      final List<dynamic> data = response.data['data'];
      return data.map((json) => LandModel.fromJson(json)).toList();
    }

    return [];
  }

  @override
  Future<String> addToWishlist({required List<int> landIds}) async {
    final response = await _apiService.post<Map<String, dynamic>>(
      '/buyer/wishlist',
      data: <String, dynamic>{'land_id': landIds},
    );

    final responseData = response.data;
    if (responseData == null) {
      return 'Land added to wishlist successfully';
    }

    return responseData['message'] as String? ??
        'Land added to wishlist successfully';
  }

  @override
  Future<List<StateModel>> getLocations() async {
    final response = await _apiService.get('/location');

    if (response.data != null && response.data['success'] == true) {
      final List<dynamic> data = response.data['data'];
      return data
          .map((json) => StateModel.fromJson(json as Map<String, dynamic>))
          .toList();
    }

    return [];
  }
}
