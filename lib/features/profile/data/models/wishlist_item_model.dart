import 'package:garuda_user_app/features/profile/domain/entities/wishlist_item_entity.dart';

class WishlistItemModel {
  const WishlistItemModel({
    required this.id,
    required this.landId,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    required this.land,
  });

  factory WishlistItemModel.fromJson(Map<String, dynamic> json) {
    return WishlistItemModel(
      id: json['id'] as int? ?? 0,
      landId: json['land_id'] as int? ?? 0,
      userId: json['user_id'] as int? ?? 0,
      createdAt: _parseDateTime(json['created_at']),
      updatedAt: _parseDateTime(json['updated_at']),
      land: WishlistLandModel.fromJson(
        json['wishListLands'] as Map<String, dynamic>? ?? <String, dynamic>{},
      ),
    );
  }

  final int id;
  final int landId;
  final int userId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final WishlistLandModel land;

  WishlistItemEntity toEntity() {
    return WishlistItemEntity(
      id: id,
      landId: landId,
      userId: userId,
      createdAt: createdAt,
      updatedAt: updatedAt,
      land: land.toEntity(),
    );
  }
}

class WishlistLandModel {
  const WishlistLandModel({
    required this.id,
    required this.state,
    required this.district,
    required this.mandal,
    required this.village,
    required this.locationLatitude,
    required this.locationLongitude,
    required this.landStatus,
    required this.urgencyListing,
    required this.verificationPackage,
    required this.createdBy,
    required this.verifiedBy,
    required this.formStatus,
    required this.availability,
    required this.createdAt,
    required this.updatedAt,
  });

  factory WishlistLandModel.fromJson(Map<String, dynamic> json) {
    return WishlistLandModel(
      id: json['id'] as int? ?? 0,
      state: json['state'] as String? ?? '',
      district: json['district'] as String? ?? '',
      mandal: json['mandal'] as String? ?? '',
      village: json['village'] as String? ?? '',
      locationLatitude: json['location_latitude'] as String? ?? '',
      locationLongitude: json['location_longitude'] as String? ?? '',
      landStatus: _parseStringList(json['land_status']),
      urgencyListing: _parseStringList(json['urgency_listing']),
      verificationPackage: json['verification_package'] as bool? ?? false,
      createdBy: json['created_by'] as int? ?? 0,
      verifiedBy: json['verified_by'] as int?,
      formStatus: json['form_status'] as String? ?? '',
      availability:
          json['availablity'] as String? ??
          json['availability'] as String? ??
          '',
      createdAt: _parseDateTime(json['created_at']),
      updatedAt: _parseDateTime(json['updated_at']),
    );
  }

  final int id;
  final String state;
  final String district;
  final String mandal;
  final String village;
  final String locationLatitude;
  final String locationLongitude;
  final List<String> landStatus;
  final List<String> urgencyListing;
  final bool verificationPackage;
  final int createdBy;
  final int? verifiedBy;
  final String formStatus;
  final String availability;
  final DateTime createdAt;
  final DateTime updatedAt;

  WishlistLandEntity toEntity() {
    return WishlistLandEntity(
      id: id,
      state: state,
      district: district,
      mandal: mandal,
      village: village,
      locationLatitude: locationLatitude,
      locationLongitude: locationLongitude,
      landStatus: landStatus,
      urgencyListing: urgencyListing,
      verificationPackage: verificationPackage,
      createdBy: createdBy,
      verifiedBy: verifiedBy,
      formStatus: formStatus,
      availability: availability,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

List<String> _parseStringList(Object? value) {
  if (value is List) {
    return value.map((item) => item.toString()).toList();
  }

  return const <String>[];
}

DateTime _parseDateTime(Object? value) {
  if (value is String) {
    return DateTime.tryParse(value) ?? DateTime.fromMillisecondsSinceEpoch(0);
  }

  return DateTime.fromMillisecondsSinceEpoch(0);
}
