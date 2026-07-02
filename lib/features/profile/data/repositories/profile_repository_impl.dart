import 'package:garuda_user_app/core/data/repository_executor.dart';
import 'package:garuda_user_app/core/utils/result.dart';
import 'package:garuda_user_app/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:garuda_user_app/features/profile/domain/entities/availability_entity.dart';
import 'package:garuda_user_app/features/profile/domain/entities/cart_item_entity.dart';
import 'package:garuda_user_app/features/profile/domain/entities/shortlist_item_entity.dart';
import 'package:garuda_user_app/features/profile/domain/entities/visit_item_entity.dart';
import 'package:garuda_user_app/features/profile/domain/entities/wishlist_item_entity.dart';
import 'package:garuda_user_app/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  const ProfileRepositoryImpl(this._remoteDataSource);

  final ProfileRemoteDataSource _remoteDataSource;

  @override
  Future<Result<List<WishlistItemEntity>>> getWishlist() {
    return RepositoryExecutor.runSafely(() async {
      final wishlistModels = await _remoteDataSource.getWishlist();
      return wishlistModels.map((item) => item.toEntity()).toList();
    });
  }

  @override
  Future<Result<String>> addToWishlist({required List<int> landIds}) {
    return RepositoryExecutor.runSafely(
      () => _remoteDataSource.addToWishlist(landIds: landIds),
    );
  }

  @override
  Future<Result<String>> createAvailability({required List<int> landIds}) {
    return RepositoryExecutor.runSafely(
      () => _remoteDataSource.createAvailability(landIds: landIds),
    );
  }

  @override
  Future<Result<List<AvailabilityEntity>>> getAvailabilities() {
    return RepositoryExecutor.runSafely(() async {
      final availabilityModels = await _remoteDataSource.getAvailabilities();
      return availabilityModels.map((item) => item.toEntity()).toList();
    });
  }

  @override
  Future<Result<String>> createCart({required List<int> landIds}) {
    return RepositoryExecutor.runSafely(
      () => _remoteDataSource.createCart(landIds: landIds),
    );
  }

  @override
  Future<Result<List<CartItemEntity>>> getCart() {
    return RepositoryExecutor.runSafely(() async {
      final cartModels = await _remoteDataSource.getCart();
      return cartModels.map((item) => item.toEntity()).toList();
    });
  }

  @override
  Future<Result<List<VisitItemEntity>>> getVisits() {
    return RepositoryExecutor.runSafely(() async {
      final visitModels = await _remoteDataSource.getVisits();
      return visitModels.map((item) => item.toEntity()).toList();
    });
  }

  @override
  Future<Result<List<ShortlistItemEntity>>> getShortlists() {
    return RepositoryExecutor.runSafely(() async {
      final shortlistModels = await _remoteDataSource.getShortlists();
      return shortlistModels.map((item) => item.toEntity()).toList();
    });
  }

  @override
  Future<Result<List<ShortlistItemEntity>>> getFinals() {
    return RepositoryExecutor.runSafely(() async {
      final finalModels = await _remoteDataSource.getFinals();
      return finalModels.map((item) => item.toEntity()).toList();
    });
  }

  @override
  Future<Result<String>> createShortlist({required int landId}) {
    return RepositoryExecutor.runSafely(
      () => _remoteDataSource.createShortlist(landId: landId),
    );
  }

  @override
  Future<Result<String>> deleteShortlist({required int landId}) {
    return RepositoryExecutor.runSafely(
      () => _remoteDataSource.deleteShortlist(landId: landId),
    );
  }

  @override
  Future<Result<String>> createFinal({required int landId}) {
    return RepositoryExecutor.runSafely(
      () => _remoteDataSource.createFinal(landId: landId),
    );
  }

  @override
  Future<Result<String>> deleteFinal({required int landId}) {
    return RepositoryExecutor.runSafely(
      () => _remoteDataSource.deleteFinal(landId: landId),
    );
  }

  @override
  Future<Result<String>> createPayment({
    required List<int> landIds,
    required int amount,
    required String paymentStatus,
  }) {
    return RepositoryExecutor.runSafely(
      () => _remoteDataSource.createPayment(
        landIds: landIds,
        amount: amount,
        paymentStatus: paymentStatus,
      ),
    );
  }

  @override
  Future<Result<String>> createVisit({
    required List<int> landIds,
    required String visitDate,
    required String time,
    required String meetingStatus,
  }) {
    return RepositoryExecutor.runSafely(
      () => _remoteDataSource.createVisit(
        landIds: landIds,
        visitDate: visitDate,
        time: time,
        meetingStatus: meetingStatus,
      ),
    );
  }
}
