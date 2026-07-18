import 'package:equatable/equatable.dart';

class LandEntity extends Equatable {
  final int id;
  final String village;
  final String state;
  final String district;
  final String mandal;
  final List<String> landStatus;
  final List<String> mortgageStatus;
  final List<String> urgencyListing;
  final bool verificationPackage;
  final bool isVerified;
  final String? verificationStatus;
  final String? nearestTownKm;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final LandDetailsEntity landDetails;
  final List<MediaEntity> media;
  final List<DocumentEntity> documents;

  const LandEntity({
    required this.id,
    required this.village,
    required this.state,
    required this.district,
    required this.mandal,
    required this.landStatus,
    required this.mortgageStatus,
    required this.urgencyListing,
    required this.verificationPackage,
    required this.isVerified,
    this.verificationStatus,
    this.nearestTownKm,
    this.createdAt,
    this.updatedAt,
    required this.landDetails,
    required this.media,
    required this.documents,
  });

  @override
  List<Object?> get props => [
        id,
        village,
        state,
        district,
        mandal,
        landStatus,
        mortgageStatus,
        urgencyListing,
        verificationPackage,
        isVerified,
        verificationStatus,
        nearestTownKm,
        createdAt,
        updatedAt,
        landDetails,
        media,
        documents,
      ];
}

class LandDetailsEntity extends Equatable {
  final double totalAcres;
  final int guntas;
  final double pricePerAcres;
  final double totalValue;
  final String soilType;
  final String nearestRoadType;
  final String landAttachedToRoad;
  final String fencingStatus;
  final List<String> waterSource;
  final List<String> electricity;
  final List<String> residence;
  final int numberOfBores;
  final bool farmPond;
  final int poultryShedNumber;
  final int cowShedNumber;
  final List<TreeEntity> trees;

  const LandDetailsEntity({
    required this.totalAcres,
    required this.guntas,
    required this.pricePerAcres,
    required this.totalValue,
    required this.soilType,
    required this.nearestRoadType,
    required this.landAttachedToRoad,
    required this.fencingStatus,
    required this.waterSource,
    required this.electricity,
    required this.residence,
    required this.numberOfBores,
    required this.farmPond,
    required this.poultryShedNumber,
    required this.cowShedNumber,
    required this.trees,
  });

  @override
  List<Object?> get props => [
        totalAcres,
        guntas,
        pricePerAcres,
        totalValue,
        soilType,
        nearestRoadType,
        landAttachedToRoad,
        fencingStatus,
        waterSource,
        electricity,
        residence,
        numberOfBores,
        farmPond,
        poultryShedNumber,
        cowShedNumber,
        trees,
      ];
}

class MediaEntity extends Equatable {
  final String url;
  final String type;
  final String category;

  const MediaEntity({required this.url, required this.type, required this.category});

  /// Categories that must not be shown to buyers (farmer identity / agreement docs).
  /// Matches backend `land_media.category` enum in Garuda-Backend-2.
  static const Set<String> buyerHiddenCategories = <String>{
    'farmer_photo',
    'farmer_aggrement', // backend spelling
    'farmer_agreement',
  };

  /// Land images suitable for buyer listing cards and visual documentation.
  bool get isBuyerFacingImage =>
      type == 'image' && !buyerHiddenCategories.contains(category);

  @override
  List<Object?> get props => [url, type, category];
}

class DocumentEntity extends Equatable {
  final String docType;
  final String fileUrl;

  const DocumentEntity({required this.docType, required this.fileUrl});

  @override
  List<Object?> get props => [docType, fileUrl];
}

class TreeEntity extends Equatable {
  final String type;
  final int count;

  const TreeEntity({required this.type, required this.count});

  @override
  List<Object?> get props => [type, count];
}
