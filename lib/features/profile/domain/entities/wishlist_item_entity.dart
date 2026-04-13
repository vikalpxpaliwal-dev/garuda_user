import 'package:equatable/equatable.dart';

class WishlistItemEntity extends Equatable {
  const WishlistItemEntity({
    required this.id,
    required this.landId,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    required this.land,
  });

  final int id;
  final int landId;
  final int userId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final WishlistLandEntity land;

  @override
  List<Object?> get props => [id, landId, userId, createdAt, updatedAt, land];
}

class WishlistLandEntity extends Equatable {
  const WishlistLandEntity({
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

  @override
  List<Object?> get props => [
        id,
        state,
        district,
        mandal,
        village,
        locationLatitude,
        locationLongitude,
        landStatus,
        urgencyListing,
        verificationPackage,
        createdBy,
        verifiedBy,
        formStatus,
        availability,
        createdAt,
        updatedAt,
      ];
}
