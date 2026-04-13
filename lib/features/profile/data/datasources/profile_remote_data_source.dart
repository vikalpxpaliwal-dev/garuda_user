import 'package:garuda_user_app/core/network/api_service.dart';
import 'package:garuda_user_app/features/profile/data/models/wishlist_item_model.dart';

abstract interface class ProfileRemoteDataSource {
  Future<List<WishlistItemModel>> getWishlist();
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
}
