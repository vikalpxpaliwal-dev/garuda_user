import 'package:equatable/equatable.dart';
import 'package:garuda_user_app/features/profile/domain/entities/availability_entity.dart';

enum CreateAvailabilityStatus { initial, loading, success, failure }
enum GetAvailabilityStatus { initial, loading, success, failure }

class AvailabilityState extends Equatable {
  const AvailabilityState({
    this.createStatus = CreateAvailabilityStatus.initial,
    this.getStatus = GetAvailabilityStatus.initial,
    this.errorMessage,
    this.items = const <AvailabilityEntity>[],
  });

  final CreateAvailabilityStatus createStatus;
  final GetAvailabilityStatus getStatus;
  final String? errorMessage;
  final List<AvailabilityEntity> items;

  AvailabilityState copyWith({
    CreateAvailabilityStatus? createStatus,
    GetAvailabilityStatus? getStatus,
    String? errorMessage,
    List<AvailabilityEntity>? items,
  }) {
    return AvailabilityState(
      createStatus: createStatus ?? this.createStatus,
      getStatus: getStatus ?? this.getStatus,
      errorMessage: errorMessage,
      items: items ?? this.items,
    );
  }

  @override
  List<Object?> get props => [createStatus, getStatus, errorMessage, items];
}
