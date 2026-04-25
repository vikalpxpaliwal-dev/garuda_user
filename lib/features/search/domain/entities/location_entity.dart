import 'package:equatable/equatable.dart';

class StateEntity extends Equatable {
  final int id;
  final String name;
  final List<DistrictEntity> districts;

  const StateEntity({
    required this.id,
    required this.name,
    required this.districts,
  });

  @override
  List<Object?> get props => [id, name, districts];
}

class DistrictEntity extends Equatable {
  final int id;
  final int stateId;
  final String name;
  final List<MandalEntity> mandals;

  const DistrictEntity({
    required this.id,
    required this.stateId,
    required this.name,
    required this.mandals,
  });

  @override
  List<Object?> get props => [id, stateId, name, mandals];
}

class MandalEntity extends Equatable {
  final int id;
  final int districtId;
  final String name;
  final List<VillageEntity> villages;

  const MandalEntity({
    required this.id,
    required this.districtId,
    required this.name,
    required this.villages,
  });

  @override
  List<Object?> get props => [id, districtId, name, villages];
}

class VillageEntity extends Equatable {
  final int id;
  final int mandalId;
  final String name;

  const VillageEntity({
    required this.id,
    required this.mandalId,
    required this.name,
  });

  @override
  List<Object?> get props => [id, mandalId, name];
}
