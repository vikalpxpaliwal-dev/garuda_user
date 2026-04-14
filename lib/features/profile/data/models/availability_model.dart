import 'package:garuda_user_app/features/profile/data/models/wishlist_item_model.dart';
import 'package:garuda_user_app/features/profile/domain/entities/availability_entity.dart';

class AvailabilityModel {
  const AvailabilityModel({
    required this.id,
    required this.landId,
    required this.userId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.land,
  });

  factory AvailabilityModel.fromJson(Map<String, dynamic> json) {
    return AvailabilityModel(
      id: json['id'] as int? ?? 0,
      landId: json['land_id'] as int? ?? 0,
      userId: json['user_id'] as int? ?? 0,
      status: json['status'] as String? ?? 'active',
      createdAt: _parseDateTime(json['created_at']),
      updatedAt: _parseDateTime(json['updated_at']),
      land: WishlistLandModel.fromJson(
        json['availibilityLand'] as Map<String, dynamic>? ??
            json['wishListLands'] as Map<String, dynamic>? ??
            <String, dynamic>{},
      ),
    );
  }

  final int id;
  final int landId;
  final int userId;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final WishlistLandModel land;

  AvailabilityEntity toEntity() {
    return AvailabilityEntity(
      id: id,
      landId: landId,
      userId: userId,
      status: status,
      createdAt: createdAt,
      updatedAt: updatedAt,
      land: land.toEntity(),
    );
  }
}

DateTime _parseDateTime(Object? value) {
  if (value is String) {
    return DateTime.tryParse(value) ?? DateTime.fromMillisecondsSinceEpoch(0);
  }

  return DateTime.fromMillisecondsSinceEpoch(0);
}
