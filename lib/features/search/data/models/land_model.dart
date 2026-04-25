import 'package:garuda_user_app/features/search/domain/entities/land_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'land_model.g.dart';

@JsonSerializable()
class LandModel {
  final int id;
  final String state;
  final String district;
  final String mandal;
  final String village;
  @JsonKey(name: 'location_latitude')
  final String locationLatitude;
  @JsonKey(name: 'location_longitude')
  final String locationLongitude;
  @JsonKey(name: 'land_status')
  final List<String> landStatus;
  @JsonKey(name: 'urgency_listing')
  final List<String> urgencyListing;
  @JsonKey(name: 'verification_package')
  final bool verificationPackage;
  @JsonKey(name: 'created_by')
  final int createdBy;
  @JsonKey(name: 'verified_by')
  final dynamic verifiedBy;
  @JsonKey(name: 'form_status')
  final String formStatus;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String updatedAt;
  final LandDetailsModel landDetails;
  final GpsModel? gps;
  final List<MediaModel> media;
  final List<DocumentModel> documents;

  const LandModel({
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
    this.verifiedBy,
    required this.formStatus,
    required this.createdAt,
    required this.updatedAt,
    required this.landDetails,
    this.gps,
    required this.media,
    required this.documents,
  });

  factory LandModel.fromJson(Map<String, dynamic> json) =>
      _$LandModelFromJson(json);

  Map<String, dynamic> toJson() => _$LandModelToJson(this);

  LandEntity toEntity() => LandEntity(
        id: id,
        village: village,
        state: state,
        district: district,
        mandal: mandal,
        landStatus: landStatus,
        urgencyListing: urgencyListing,
        landDetails: landDetails.toEntity(),
        media: media.map((m) => m.toEntity()).toList(),
        documents: documents.map((d) => d.toEntity()).toList(),
      );
}

@JsonSerializable()
class LandDetailsModel {
  final int id;
  @JsonKey(name: 'land_id')
  final int landId;
  @JsonKey(name: 'total_acres')
  final double totalAcres;
  final int guntas;
  @JsonKey(name: 'price_per_acres')
  final double pricePerAcres;
  @JsonKey(name: 'total_value')
  final double totalValue;
  @JsonKey(name: 'nearest_road_type')
  final String nearestRoadType;
  @JsonKey(name: 'land_attached_to_road')
  final String landAttachedToRoad;
  @JsonKey(name: 'path_ownership')
  final String pathOwnership;
  @JsonKey(name: 'land_entry_latitude')
  final String landEntryLatitude;
  @JsonKey(name: 'land_entry_longitude')
  final String landEntryLongitude;
  @JsonKey(name: 'land_boundary_latitude')
  final String landBoundaryLatitude;
  @JsonKey(name: 'land_boundary_longitude')
  final String landBoundaryLongitude;
  @JsonKey(name: 'soil_type')
  final String soilType;
  @JsonKey(name: 'fencing_status')
  final String fencingStatus;
  final List<String> electricity;
  final List<String> residence;
  @JsonKey(name: 'poultry_shed_number')
  final int poultryShedNumber;
  @JsonKey(name: 'cow_shed_number')
  final int cowShedNumber;
  @JsonKey(name: 'water_source')
  final List<String> waterSource;
  @JsonKey(name: 'number_of_bores')
  final int numberOfBores;
  @JsonKey(name: 'farm_pond')
  final bool farmPond;
  @JsonKey(name: 'mango_trees_number')
  final String mangoTreesNumber;
  @JsonKey(name: 'coconut_trees_number')
  final String coconutTreesNumber;
  @JsonKey(name: 'neem_trees_number')
  final String neem_trees_number;
  @JsonKey(name: 'baniyan_trees_number')
  final String baniyanTreesNumber;
  @JsonKey(name: 'tamarind_trees_number')
  final String tamarindTreesNumber;
  @JsonKey(name: 'sapoto_trees_number')
  final String sapotoTreesNumber;
  @JsonKey(name: 'guava_trees_number')
  final String guavaTreesNumber;
  @JsonKey(name: 'teak_trees_number')
  final String teakTreesNumber;
  @JsonKey(name: 'other_trees_number')
  final String otherTreesNumber;
  final List<String> complaints;

  const LandDetailsModel({
    required this.id,
    required this.landId,
    required this.totalAcres,
    required this.guntas,
    required this.pricePerAcres,
    required this.totalValue,
    required this.nearestRoadType,
    required this.landAttachedToRoad,
    required this.pathOwnership,
    required this.landEntryLatitude,
    required this.landEntryLongitude,
    required this.landBoundaryLatitude,
    required this.landBoundaryLongitude,
    required this.soilType,
    required this.fencingStatus,
    required this.electricity,
    required this.residence,
    required this.poultryShedNumber,
    required this.cowShedNumber,
    required this.waterSource,
    required this.numberOfBores,
    required this.farmPond,
    required this.mangoTreesNumber,
    required this.coconutTreesNumber,
    required this.neem_trees_number,
    required this.baniyanTreesNumber,
    required this.tamarindTreesNumber,
    required this.sapotoTreesNumber,
    required this.guavaTreesNumber,
    required this.teakTreesNumber,
    required this.otherTreesNumber,
    required this.complaints,
  });

  factory LandDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$LandDetailsModelFromJson(json);

  Map<String, dynamic> toJson() => _$LandDetailsModelToJson(this);

  LandDetailsEntity toEntity() => LandDetailsEntity(
        totalAcres: totalAcres,
        guntas: guntas,
        pricePerAcres: pricePerAcres,
        totalValue: totalValue,
        soilType: soilType,
        nearestRoadType: nearestRoadType,
        landAttachedToRoad: landAttachedToRoad,
        fencingStatus: fencingStatus,
        waterSource: waterSource,
        electricity: electricity,
        residence: residence,
        numberOfBores: numberOfBores,
        farmPond: farmPond,
        mangoTreesNumber: mangoTreesNumber,
        coconutTreesNumber: coconutTreesNumber,
        neemTreesNumber: neem_trees_number,
        baniyanTreesNumber: baniyanTreesNumber,
        tamarindTreesNumber: tamarindTreesNumber,
        sapotoTreesNumber: sapotoTreesNumber,
        guavaTreesNumber: guavaTreesNumber,
        teakTreesNumber: teakTreesNumber,
        otherTreesNumber: otherTreesNumber,
      );
}

@JsonSerializable()
class GpsModel {
  final int id;
  @JsonKey(name: 'land_id')
  final int landId;
  final String latitude;
  final String longitude;

  const GpsModel({
    required this.id,
    required this.landId,
    required this.latitude,
    required this.longitude,
  });

  factory GpsModel.fromJson(Map<String, dynamic> json) =>
      _$GpsModelFromJson(json);

  Map<String, dynamic> toJson() => _$GpsModelToJson(this);
}

@JsonSerializable()
class MediaModel {
  final int id;
  @JsonKey(name: 'land_id')
  final int landId;
  final String category;
  final String type;
  final String url;

  const MediaModel({
    required this.id,
    required this.landId,
    required this.category,
    required this.type,
    required this.url,
  });

  factory MediaModel.fromJson(Map<String, dynamic> json) =>
      _$MediaModelFromJson(json);

  Map<String, dynamic> toJson() => _$MediaModelToJson(this);

  MediaEntity toEntity() => MediaEntity(url: url, type: type, category: category);
}

@JsonSerializable()
class DocumentModel {
  final int id;
  @JsonKey(name: 'land_id')
  final int landId;
  @JsonKey(name: 'doc_type')
  final String docType;
  @JsonKey(name: 'file_url')
  final String fileUrl;

  const DocumentModel({
    required this.id,
    required this.landId,
    required this.docType,
    required this.fileUrl,
  });

  factory DocumentModel.fromJson(Map<String, dynamic> json) =>
      _$DocumentModelFromJson(json);

  Map<String, dynamic> toJson() => _$DocumentModelToJson(this);

  DocumentEntity toEntity() => DocumentEntity(docType: docType, fileUrl: fileUrl);
}
