import 'package:equatable/equatable.dart';
import 'package:garuda_user_app/features/profile/domain/entities/wishlist_item_entity.dart';

class AvailabilityEntity extends Equatable {
  const AvailabilityEntity({
    required this.id,
    required this.landId,
    required this.userId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.land,
  });

  final int id;
  final int landId;
  final int userId;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final WishlistLandEntity land;

  @override
  List<Object?> get props => [
        id,
        landId,
        userId,
        status,
        createdAt,
        updatedAt,
        land,
      ];
}
