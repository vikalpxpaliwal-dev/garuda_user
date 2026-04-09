// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'land_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LandModel _$LandModelFromJson(Map<String, dynamic> json) => LandModel(
  id: (json['id'] as num).toInt(),
  state: json['state'] as String,
  district: json['district'] as String,
  mandal: json['mandal'] as String,
  village: json['village'] as String,
  locationLatitude: json['location_latitude'] as String,
  locationLongitude: json['location_longitude'] as String,
  landStatus: (json['land_status'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  urgencyListing: (json['urgency_listing'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  verificationPackage: json['verification_package'] as bool,
  createdBy: (json['created_by'] as num).toInt(),
  verifiedBy: json['verified_by'],
  formStatus: json['form_status'] as String,
  createdAt: json['created_at'] as String,
  updatedAt: json['updated_at'] as String,
  landDetails: LandDetailsModel.fromJson(
    json['landDetails'] as Map<String, dynamic>,
  ),
  gps: json['gps'] == null
      ? null
      : GpsModel.fromJson(json['gps'] as Map<String, dynamic>),
  media: (json['media'] as List<dynamic>)
      .map((e) => MediaModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  documents: (json['documents'] as List<dynamic>)
      .map((e) => DocumentModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$LandModelToJson(LandModel instance) => <String, dynamic>{
  'id': instance.id,
  'state': instance.state,
  'district': instance.district,
  'mandal': instance.mandal,
  'village': instance.village,
  'location_latitude': instance.locationLatitude,
  'location_longitude': instance.locationLongitude,
  'land_status': instance.landStatus,
  'urgency_listing': instance.urgencyListing,
  'verification_package': instance.verificationPackage,
  'created_by': instance.createdBy,
  'verified_by': instance.verifiedBy,
  'form_status': instance.formStatus,
  'created_at': instance.createdAt,
  'updated_at': instance.updatedAt,
  'landDetails': instance.landDetails,
  'gps': instance.gps,
  'media': instance.media,
  'documents': instance.documents,
};

LandDetailsModel _$LandDetailsModelFromJson(Map<String, dynamic> json) =>
    LandDetailsModel(
      id: (json['id'] as num).toInt(),
      landId: (json['land_id'] as num).toInt(),
      totalAcres: (json['total_acres'] as num).toDouble(),
      guntas: (json['guntas'] as num).toInt(),
      pricePerAcres: (json['price_per_acres'] as num).toDouble(),
      totalValue: (json['total_value'] as num).toDouble(),
      nearestRoadType: json['nearest_road_type'] as String,
      landAttachedToRoad: json['land_attached_to_road'] as String,
      pathOwnership: json['path_ownership'] as String,
      landEntryLatitude: json['land_entry_latitude'] as String,
      landEntryLongitude: json['land_entry_longitude'] as String,
      landBoundaryLatitude: json['land_boundary_latitude'] as String,
      landBoundaryLongitude: json['land_boundary_longitude'] as String,
      soilType: json['soil_type'] as String,
      fencingStatus: json['fencing_status'] as String,
      electricity: (json['electricity'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      residence: (json['residence'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      poultryShedNumber: (json['poultry_shed_number'] as num).toInt(),
      cowShedNumber: (json['cow_shed_number'] as num).toInt(),
      waterSource: (json['water_source'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      numberOfBores: (json['number_of_bores'] as num).toInt(),
      farmPond: json['farm_pond'] as bool,
      mangoTreesNumber: json['mango_trees_number'] as String,
      coconutTreesNumber: json['coconut_trees_number'] as String,
      neem_trees_number: json['neem_trees_number'] as String,
      baniyanTreesNumber: json['baniyan_trees_number'] as String,
      tamarindTreesNumber: json['tamarind_trees_number'] as String,
      sapotoTreesNumber: json['sapoto_trees_number'] as String,
      guavaTreesNumber: json['guava_trees_number'] as String,
      teakTreesNumber: json['teak_trees_number'] as String,
      otherTreesNumber: json['other_trees_number'] as String,
      complaints: (json['complaints'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$LandDetailsModelToJson(LandDetailsModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'land_id': instance.landId,
      'total_acres': instance.totalAcres,
      'guntas': instance.guntas,
      'price_per_acres': instance.pricePerAcres,
      'total_value': instance.totalValue,
      'nearest_road_type': instance.nearestRoadType,
      'land_attached_to_road': instance.landAttachedToRoad,
      'path_ownership': instance.pathOwnership,
      'land_entry_latitude': instance.landEntryLatitude,
      'land_entry_longitude': instance.landEntryLongitude,
      'land_boundary_latitude': instance.landBoundaryLatitude,
      'land_boundary_longitude': instance.landBoundaryLongitude,
      'soil_type': instance.soilType,
      'fencing_status': instance.fencingStatus,
      'electricity': instance.electricity,
      'residence': instance.residence,
      'poultry_shed_number': instance.poultryShedNumber,
      'cow_shed_number': instance.cowShedNumber,
      'water_source': instance.waterSource,
      'number_of_bores': instance.numberOfBores,
      'farm_pond': instance.farmPond,
      'mango_trees_number': instance.mangoTreesNumber,
      'coconut_trees_number': instance.coconutTreesNumber,
      'neem_trees_number': instance.neem_trees_number,
      'baniyan_trees_number': instance.baniyanTreesNumber,
      'tamarind_trees_number': instance.tamarindTreesNumber,
      'sapoto_trees_number': instance.sapotoTreesNumber,
      'guava_trees_number': instance.guavaTreesNumber,
      'teak_trees_number': instance.teakTreesNumber,
      'other_trees_number': instance.otherTreesNumber,
      'complaints': instance.complaints,
    };

GpsModel _$GpsModelFromJson(Map<String, dynamic> json) => GpsModel(
  id: (json['id'] as num).toInt(),
  landId: (json['land_id'] as num).toInt(),
  latitude: json['latitude'] as String,
  longitude: json['longitude'] as String,
);

Map<String, dynamic> _$GpsModelToJson(GpsModel instance) => <String, dynamic>{
  'id': instance.id,
  'land_id': instance.landId,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
};

MediaModel _$MediaModelFromJson(Map<String, dynamic> json) => MediaModel(
  id: (json['id'] as num).toInt(),
  landId: (json['land_id'] as num).toInt(),
  category: json['category'] as String,
  type: json['type'] as String,
  url: json['url'] as String,
);

Map<String, dynamic> _$MediaModelToJson(MediaModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'land_id': instance.landId,
      'category': instance.category,
      'type': instance.type,
      'url': instance.url,
    };

DocumentModel _$DocumentModelFromJson(Map<String, dynamic> json) =>
    DocumentModel(
      id: (json['id'] as num).toInt(),
      landId: (json['land_id'] as num).toInt(),
      docType: json['doc_type'] as String,
      fileUrl: json['file_url'] as String,
    );

Map<String, dynamic> _$DocumentModelToJson(DocumentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'land_id': instance.landId,
      'doc_type': instance.docType,
      'file_url': instance.fileUrl,
    };
