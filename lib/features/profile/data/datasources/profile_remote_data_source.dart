import 'package:garuda_user_app/core/network/api_service.dart';
import 'package:garuda_user_app/features/profile/data/models/availability_model.dart';
import 'package:garuda_user_app/features/profile/data/models/cart_item_model.dart';
import 'package:garuda_user_app/features/profile/data/models/wishlist_item_model.dart';

abstract interface class ProfileRemoteDataSource {
  Future<List<WishlistItemModel>> getWishlist();
  Future<String> createAvailability({required List<int> landIds});
  Future<List<AvailabilityModel>> getAvailabilities();
  Future<String> createCart({required List<int> landIds});
  Future<List<CartItemModel>> getCart();
  Future<String> createPayment({
    required List<int> landIds,
    required int amount,
    required String paymentStatus,
  });
  Future<String> createVisit({
    required List<int> landIds,
    required String visitDate,
    required String time,
    required String meetingStatus,
  });
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

  @override
  Future<List<AvailabilityModel>> getAvailabilities() async {
    final response = await _apiService.get<Map<String, dynamic>>(
      '/buyer/availability',
    );
    final responseData = response.data;

    if (responseData == null) {
      return const <AvailabilityModel>[];
    }

    final result = responseData['result'] as List<dynamic>? ?? <dynamic>[];

    return result
        .map(
          (json) => AvailabilityModel.fromJson(json as Map<String, dynamic>),
        )
        .toList();
  }
  @override
  Future<String> createCart({required List<int> landIds}) async {
    final response = await _apiService.post<Map<String, dynamic>>(
      '/buyer/cart',
      data: <String, dynamic>{'land_id': landIds},
    );

    final responseData = response.data;
    if (responseData == null) {
      return 'Cart updated successfully';
    }

    return responseData['message'] as String? ?? 'Cart updated successfully';
  }
  @override
  Future<List<CartItemModel>> getCart() async {
    final response = await _apiService.get<Map<String, dynamic>>(
      '/buyer/cart',
    );
    final responseData = response.data;

    if (responseData == null) {
      return const <CartItemModel>[];
    }

    final result = responseData['result'] as List<dynamic>? ?? <dynamic>[];

    return result
        .map(
          (json) => CartItemModel.fromJson(json as Map<String, dynamic>),
        )
        .toList();
  }

  @override
  Future<String> createPayment({
    required List<int> landIds,
    required int amount,
    required String paymentStatus,
  }) async {
    final response = await _apiService.post<Map<String, dynamic>>(
      '/buyer/payment',
      data: <String, dynamic>{
        'land_id': landIds,
        'amount': amount,
        'payment_status': paymentStatus,
      },
    );

    final responseData = response.data;
    if (responseData == null) {
      return 'Payment initiated successfully';
    }

    return responseData['message'] as String? ?? 'Payment initiated successfully';
  }

  @override
  Future<String> createVisit({
    required List<int> landIds,
    required String visitDate,
    required String time,
    required String meetingStatus,
  }) async {
    final response = await _apiService.post<Map<String, dynamic>>(
      '/buyer/visit',
      data: <String, dynamic>{
        'land_id': landIds,
        'visit_date': visitDate,
        'time': time,
        'meeting_status': meetingStatus,
      },
    );

    final responseData = response.data;
    if (responseData == null) {
      return 'Visit scheduled successfully';
    }

    return responseData['message'] as String? ?? 'Visit scheduled successfully';
  }
}
