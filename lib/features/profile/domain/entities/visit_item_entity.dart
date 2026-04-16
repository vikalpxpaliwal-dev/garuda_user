import 'package:equatable/equatable.dart';
import 'package:garuda_user_app/features/profile/domain/entities/wishlist_item_entity.dart';

class VisitItemEntity extends Equatable {
  const VisitItemEntity({
    required this.id,
    required this.landId,
    required this.userId,
    required this.visitDate,
    required this.time,
    required this.meetingStatus,
    required this.createdAt,
    required this.updatedAt,
    required this.land,
  });

  final int id;
  final int landId;
  final int userId;
  final DateTime visitDate;
  final String time;
  final String meetingStatus;
  final DateTime createdAt;
  final DateTime updatedAt;
  final WishlistLandEntity land;

  @override
  List<Object?> get props => [
        id,
        landId,
        userId,
        visitDate,
        time,
        meetingStatus,
        createdAt,
        updatedAt,
        land,
      ];
}
