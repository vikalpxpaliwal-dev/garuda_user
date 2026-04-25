import 'package:equatable/equatable.dart';

class LandEntity extends Equatable {
  final int id;
  final String village;
  final String state;
  final String district;
  final String mandal;
  final List<String> landStatus;
  final List<String> urgencyListing;
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
    required this.urgencyListing,
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
        urgencyListing,
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
  final String mangoTreesNumber;
  final String coconutTreesNumber;
  final String neemTreesNumber;
  final String baniyanTreesNumber;
  final String tamarindTreesNumber;
  final String sapotoTreesNumber;
  final String guavaTreesNumber;
  final String teakTreesNumber;
  final String otherTreesNumber;

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
    required this.mangoTreesNumber,
    required this.coconutTreesNumber,
    required this.neemTreesNumber,
    required this.baniyanTreesNumber,
    required this.tamarindTreesNumber,
    required this.sapotoTreesNumber,
    required this.guavaTreesNumber,
    required this.teakTreesNumber,
    required this.otherTreesNumber,
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
        mangoTreesNumber,
        coconutTreesNumber,
        neemTreesNumber,
        baniyanTreesNumber,
        tamarindTreesNumber,
        sapotoTreesNumber,
        guavaTreesNumber,
        teakTreesNumber,
        otherTreesNumber,
      ];
}

class MediaEntity extends Equatable {
  final String url;
  final String type;
  final String category;

  const MediaEntity({required this.url, required this.type, required this.category});

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
