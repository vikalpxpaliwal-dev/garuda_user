import 'package:garuda_user_app/core/error/exceptions.dart';
import 'package:garuda_user_app/core/error/failures.dart';
import 'package:garuda_user_app/core/utils/result.dart';
import 'package:garuda_user_app/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:garuda_user_app/features/profile/domain/entities/availability_entity.dart';
import 'package:garuda_user_app/features/profile/domain/entities/cart_item_entity.dart';
import 'package:garuda_user_app/features/profile/domain/entities/wishlist_item_entity.dart';
import 'package:garuda_user_app/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  const ProfileRepositoryImpl(this._remoteDataSource);

  final ProfileRemoteDataSource _remoteDataSource;

  @override
  Future<Result<List<WishlistItemEntity>>> getWishlist() async {
    try {
      final wishlistModels = await _remoteDataSource.getWishlist();
      final wishlistItems = wishlistModels.map((item) => item.toEntity()).toList();

      return Success(wishlistItems);
    } on AppException catch (e) {
      if (e is NetworkException) {
        return Error(NetworkFailure(message: e.message, statusCode: e.statusCode));
      }

      return Error(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e) {
      return Error(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<String>> createAvailability({required List<int> landIds}) async {
    try {
      final message = await _remoteDataSource.createAvailability(landIds: landIds);
      return Success(message);
    } on AppException catch (e) {
      if (e is NetworkException) {
        return Error(NetworkFailure(message: e.message, statusCode: e.statusCode));
      }

      return Error(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e) {
      return Error(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<List<AvailabilityEntity>>> getAvailabilities() async {
    try {
      final availabilityModels = await _remoteDataSource.getAvailabilities();
      final availabilityEntities =
          availabilityModels.map((item) => item.toEntity()).toList();

      return Success(availabilityEntities);
    } on AppException catch (e) {
      if (e is NetworkException) {
        return Error(NetworkFailure(message: e.message, statusCode: e.statusCode));
      }

      return Error(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e) {
      return Error(ServerFailure(message: e.toString()));
    }
  }
  @override
  Future<Result<String>> createCart({required List<int> landIds}) async {
    try {
      final message = await _remoteDataSource.createCart(landIds: landIds);
      return Success(message);
    } on AppException catch (e) {
      if (e is NetworkException) {
        return Error(NetworkFailure(message: e.message, statusCode: e.statusCode));
      }

      return Error(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e) {
      return Error(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<List<CartItemEntity>>> getCart() async {
    try {
      final cartModels = await _remoteDataSource.getCart();
      final cartItems = cartModels.map((item) => item.toEntity()).toList();
      return Success(cartItems);
    } on AppException catch (e) {
      if (e is NetworkException) {
        return Error(NetworkFailure(message: e.message, statusCode: e.statusCode));
      }

      return Error(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e) {
      return Error(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<String>> createPayment({
    required List<int> landIds,
    required int amount,
    required String paymentStatus,
  }) async {
    try {
      final message = await _remoteDataSource.createPayment(
        landIds: landIds,
        amount: amount,
        paymentStatus: paymentStatus,
      );
      return Success(message);
    } on AppException catch (e) {
      if (e is NetworkException) {
        return Error(NetworkFailure(message: e.message, statusCode: e.statusCode));
      }
      return Error(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e) {
      return Error(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<String>> createVisit({
    required List<int> landIds,
    required String visitDate,
    required String time,
    required String meetingStatus,
  }) async {
    try {
      final message = await _remoteDataSource.createVisit(
        landIds: landIds,
        visitDate: visitDate,
        time: time,
        meetingStatus: meetingStatus,
      );
      return Success(message);
    } on AppException catch (e) {
      if (e is NetworkException) {
        return Error(NetworkFailure(message: e.message, statusCode: e.statusCode));
      }
      return Error(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e) {
      return Error(ServerFailure(message: e.toString()));
    }
  }
}
