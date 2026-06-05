import 'package:garuda_user_app/features/search/domain/entities/land_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'land_model.g.dart';

@JsonSerializable()
class LandModel {
  final int id;
  final String? state;
  final String? district;
  final String? mandal;
  final String? village;
  @JsonKey(name: 'location_latitude')
  final String? locationLatitude;
  @JsonKey(name: 'location_longitude')
  final String? locationLongitude;
  @JsonKey(name: 'land_sale_available_status', defaultValue: [])
  final List<String> landStatus;
  @JsonKey(name: 'urgency_listing', defaultValue: [])
  final List<String> urgencyListing;
  @JsonKey(name: 'verification_package', defaultValue: false)
  final bool verificationPackage;
  @JsonKey(name: 'created_by')
  final int createdBy;
  @JsonKey(name: 'verified_by')
  final dynamic verifiedBy;
  @JsonKey(name: 'form_status')
  final String? formStatus;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @JsonKey(name: 'updated_at')
  final String? updatedAt;
  final LandDetailsModel landDetails;
  final GpsModel? gps;
  @JsonKey(defaultValue: [])
  final List<MediaModel> media;
  @JsonKey(defaultValue: [])
  final List<DocumentModel> documents;

  const LandModel({
    required this.id,
    this.state,
    this.district,
    this.mandal,
    this.village,
    this.locationLatitude,
    this.locationLongitude,
    required this.landStatus,
    required this.urgencyListing,
    required this.verificationPackage,
    required this.createdBy,
    this.verifiedBy,
    this.formStatus,
    this.createdAt,
    this.updatedAt,
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
        village: village ?? '',
        state: state ?? '',
        district: district ?? '',
        mandal: mandal ?? '',
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
  final double? totalAcres;
  final int? guntas;
  @JsonKey(name: 'price_per_acres')
  final double? pricePerAcres;
  @JsonKey(name: 'total_value')
  final double? totalValue;
  @JsonKey(name: 'nearest_road_type')
  final String? nearestRoadType;
  @JsonKey(name: 'land_attached_to_road')
  final String? landAttachedToRoad;
  @JsonKey(name: 'path_ownership')
  final String? pathOwnership;
  @JsonKey(name: 'land_entry_latitude')
  final String? landEntryLatitude;
  @JsonKey(name: 'land_entry_longitude')
  final String? landEntryLongitude;
  @JsonKey(name: 'land_boundary_latitude')
  final String? landBoundaryLatitude;
  @JsonKey(name: 'land_boundary_longitude')
  final String? landBoundaryLongitude;
  @JsonKey(name: 'soil_type')
  final String? soilType;
  @JsonKey(name: 'fencing_status')
  final String? fencingStatus;
  @JsonKey(defaultValue: [])
  final List<String> electricity;
  @JsonKey(defaultValue: [])
  final List<String> residence;
  @JsonKey(name: 'poultry_shed_number')
  final int? poultryShedNumber;
  @JsonKey(name: 'cow_shed_number')
  final int? cowShedNumber;
  @JsonKey(name: 'water_source', defaultValue: [])
  final List<String> waterSource;
  @JsonKey(name: 'number_of_bores')
  final int? numberOfBores;
  @JsonKey(name: 'farm_pond')
  final bool? farmPond;
  @JsonKey(readValue: _readTrees, defaultValue: [])
  final List<TreeModel> trees;

  static List<dynamic> _readTrees(Map<dynamic, dynamic> json, String key) {
    if (json[key] != null && json[key] is List) return json[key] as List<dynamic>;
    final treeKeys = {
      'mango_trees_number': 'Mango',
      'coconut_trees_number': 'Coconut',
      'neem_trees_number': 'Neem',
      'baniyan_trees_number': 'Baniyan',
      'tamarind_trees_number': 'Tamarind',
      'sapoto_trees_number': 'Sapoto',
      'guava_trees_number': 'Guava',
      'teak_trees_number': 'Teak',
      'other_trees_number': 'Other',
    };
    final List<Map<String, dynamic>> treesList = [];
    for (final entry in treeKeys.entries) {
      final val = json[entry.key];
      if (val != null && val is String && val.isNotEmpty) {
        final match = RegExp(r'\d+').firstMatch(val);
        if (match != null) {
          final count = int.tryParse(match.group(0) ?? '0') ?? 0;
          if (count > 0) {
            treesList.add({'type': entry.value, 'count': count});
          }
        }
      }
    }
    return treesList;
  }
  @JsonKey(defaultValue: [])
  final List<String> complaints;

  const LandDetailsModel({
    required this.id,
    required this.landId,
    this.totalAcres,
    this.guntas,
    this.pricePerAcres,
    this.totalValue,
    this.nearestRoadType,
    this.landAttachedToRoad,
    this.pathOwnership,
    this.landEntryLatitude,
    this.landEntryLongitude,
    this.landBoundaryLatitude,
    this.landBoundaryLongitude,
    this.soilType,
    this.fencingStatus,
    required this.electricity,
    required this.residence,
    this.poultryShedNumber,
    this.cowShedNumber,
    required this.waterSource,
    this.numberOfBores,
    this.farmPond,
    required this.trees,
    required this.complaints,
  });

  factory LandDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$LandDetailsModelFromJson(json);

  Map<String, dynamic> toJson() => _$LandDetailsModelToJson(this);

  LandDetailsEntity toEntity() => LandDetailsEntity(
        totalAcres: totalAcres ?? 0.0,
        guntas: guntas ?? 0,
        pricePerAcres: pricePerAcres ?? 0.0,
        totalValue: totalValue ?? 0.0,
        soilType: soilType ?? '',
        nearestRoadType: nearestRoadType ?? '',
        landAttachedToRoad: landAttachedToRoad ?? '',
        fencingStatus: fencingStatus ?? '',
        waterSource: waterSource,
        electricity: electricity,
        residence: residence,
        numberOfBores: numberOfBores ?? 0,
        farmPond: farmPond ?? false,
        poultryShedNumber: poultryShedNumber ?? 0,
        cowShedNumber: cowShedNumber ?? 0,
        trees: trees.map((t) => t.toEntity()).toList(),
      );
}

@JsonSerializable()
class GpsModel {
  final int id;
  @JsonKey(name: 'land_id')
  final int landId;
  final String? latitude;
  final String? longitude;

  const GpsModel({
    required this.id,
    required this.landId,
    this.latitude,
    this.longitude,
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

@JsonSerializable()
class TreeModel {
  final String type;
  final int count;

  const TreeModel({
    required this.type,
    required this.count,
  });

  factory TreeModel.fromJson(Map<String, dynamic> json) =>
      _$TreeModelFromJson(json);

  Map<String, dynamic> toJson() => _$TreeModelToJson(this);

  TreeEntity toEntity() => TreeEntity(type: type, count: count);
}
