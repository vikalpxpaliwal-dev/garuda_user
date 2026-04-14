import 'package:garuda_user_app/core/network/api_service.dart';
import 'package:garuda_user_app/features/profile/data/models/wishlist_item_model.dart';

abstract interface class ProfileRemoteDataSource {
  Future<List<WishlistItemModel>> getWishlist();
  Future<String> createAvailability({required List<int> landIds});
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  const ProfileRemoteDataSourceImpl(this._apiService);

  final ApiService _apiService;

  @override
  Future<List<WishlistItemModel>> getWishlist() async {
    final response = await _apiService.get<Map<String, dynamic>>(
      '/buyer/wishlist',
    );
    final responseData = response.data;

    if (responseData == null) {
      return const <WishlistItemModel>[];
    }

    final result = responseData['result'] as List<dynamic>? ?? <dynamic>[];

    return result
        .map(
          (json) =>
              WishlistItemModel.fromJson(json as Map<String, dynamic>),
        )
        .toList();
  }

  @override
  Future<String> createAvailability({required List<int> landIds}) async {
    final response = await _apiService.post<Map<String, dynamic>>(
      '/buyer/availability',
      data: <String, dynamic>{'land_id': landIds},
    );

    final responseData = response.data;
    if (responseData == null) {
      return 'Availability created successfully';
    }

    return responseData['message'] as String? ??
        'Availability created successfully';
  }
}
