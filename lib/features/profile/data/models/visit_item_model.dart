import 'package:garuda_user_app/features/profile/data/models/wishlist_item_model.dart';
import 'package:garuda_user_app/features/profile/domain/entities/visit_item_entity.dart';

class VisitItemModel {
  const VisitItemModel({
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

  factory VisitItemModel.fromJson(Map<String, dynamic> json) {
    return VisitItemModel(
      id: json['id'] as int? ?? 0,
      landId: json['land_id'] as int? ?? 0,
      userId: json['user_id'] as int? ?? 0,
      visitDate: _parseDateTime(json['visit_date']),
      time: json['time'] as String? ?? '',
      meetingStatus: json['meeting_status'] as String? ?? 'Scheduled',
      createdAt: _parseDateTime(json['created_at']),
      updatedAt: _parseDateTime(json['updated_at']),
      land: WishlistLandModel.fromJson(
        json['primaryVisitLand'] as Map<String, dynamic>? ??
            json['visitLand'] as Map<String, dynamic>? ??
            json['wishListLands'] as Map<String, dynamic>? ??
            json['land'] as Map<String, dynamic>? ??
            <String, dynamic>{},
      ),
    );
  }

  final int id;
  final int landId;
  final int userId;
  final DateTime visitDate;
  final String time;
  final String meetingStatus;
  final DateTime createdAt;
  final DateTime updatedAt;
  final WishlistLandModel land;

  VisitItemEntity toEntity() {
    return VisitItemEntity(
      id: id,
      landId: landId,
      userId: userId,
      visitDate: visitDate,
      time: time,
      meetingStatus: meetingStatus,
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
