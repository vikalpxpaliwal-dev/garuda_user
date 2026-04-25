import 'package:garuda_user_app/features/search/domain/entities/location_entity.dart';

class StateModel {
  final int id;
  final String name;
  final List<DistrictModel> districts;

  const StateModel({
    required this.id,
    required this.name,
    required this.districts,
  });

  factory StateModel.fromJson(Map<String, dynamic> json) {
    return StateModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      districts: (json['districts'] as List<dynamic>?)
              ?.map((d) => DistrictModel.fromJson(d as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }

  StateEntity toEntity() => StateEntity(
        id: id,
        name: name,
        districts: districts.map((d) => d.toEntity()).toList(),
      );
}

class DistrictModel {
  final int id;
  final int stateId;
  final String name;
  final List<MandalModel> mandals;

  const DistrictModel({
    required this.id,
    required this.stateId,
    required this.name,
    required this.mandals,
  });

  factory DistrictModel.fromJson(Map<String, dynamic> json) {
    return DistrictModel(
      id: json['id'] as int? ?? 0,
      stateId: json['state_id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      mandals: (json['mandals'] as List<dynamic>?)
              ?.map((m) => MandalModel.fromJson(m as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }

  DistrictEntity toEntity() => DistrictEntity(
        id: id,
        stateId: stateId,
        name: name,
        mandals: mandals.map((m) => m.toEntity()).toList(),
      );
}

class MandalModel {
  final int id;
  final int districtId;
  final String name;
  final List<VillageModel> villages;

  const MandalModel({
    required this.id,
    required this.districtId,
    required this.name,
    required this.villages,
  });

  factory MandalModel.fromJson(Map<String, dynamic> json) {
    return MandalModel(
      id: json['id'] as int? ?? 0,
      districtId: json['district_id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      villages: (json['villages'] as List<dynamic>?)
              ?.map((v) => VillageModel.fromJson(v as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }

  MandalEntity toEntity() => MandalEntity(
        id: id,
        districtId: districtId,
        name: name,
        villages: villages.map((v) => v.toEntity()).toList(),
      );
}

class VillageModel {
  final int id;
  final int mandalId;
  final String name;

  const VillageModel({
    required this.id,
    required this.mandalId,
    required this.name,
  });

  factory VillageModel.fromJson(Map<String, dynamic> json) {
    return VillageModel(
      id: json['id'] as int? ?? 0,
      mandalId: json['mandal_id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
    );
  }

  VillageEntity toEntity() => VillageEntity(
        id: id,
        mandalId: mandalId,
        name: name,
      );
}
