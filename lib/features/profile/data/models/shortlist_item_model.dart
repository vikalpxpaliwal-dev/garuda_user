import 'package:garuda_user_app/features/profile/data/models/wishlist_item_model.dart';
import 'package:garuda_user_app/features/profile/domain/entities/shortlist_item_entity.dart';

class ShortlistItemModel {
  const ShortlistItemModel({
    required this.id,
    required this.landId,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    required this.land,
  });

  factory ShortlistItemModel.fromJson(Map<String, dynamic> json) {
    return ShortlistItemModel(
      id: json['id'] as int? ?? 0,
      landId: json['land_id'] as int? ?? 0,
      userId: json['user_id'] as int? ?? 0,
      createdAt: _parseDateTime(json['created_at']),
      updatedAt: _parseDateTime(json['updated_at']),
      land: WishlistLandModel.fromJson(
        json['shortlistLand'] as Map<String, dynamic>? ??
            json['finalLand'] as Map<String, dynamic>? ??
            json['land'] as Map<String, dynamic>? ??
            <String, dynamic>{},
      ),
    );
  }

  final int id;
  final int landId;
  final int userId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final WishlistLandModel land;

  ShortlistItemEntity toEntity() {
    return ShortlistItemEntity(
      id: id,
      landId: landId,
      userId: userId,
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
