import 'package:equatable/equatable.dart';
import 'package:garuda_user_app/features/profile/domain/entities/visit_item_entity.dart';

enum CreateVisitStatus { initial, loading, success, failure }
enum GetVisitsStatus { initial, loading, success, failure }

class VisitsState extends Equatable {
  const VisitsState({
    this.createStatus = CreateVisitStatus.initial,
    this.getStatus = GetVisitsStatus.initial,
    this.createErrorMessage,
    this.getErrorMessage,
    this.items = const <VisitItemEntity>[],
  });

  final CreateVisitStatus createStatus;
  final GetVisitsStatus getStatus;
  final String? createErrorMessage;
  final String? getErrorMessage;
  final List<VisitItemEntity> items;

  VisitsState copyWith({
    CreateVisitStatus? createStatus,
    GetVisitsStatus? getStatus,
    String? createErrorMessage,
    String? getErrorMessage,
    List<VisitItemEntity>? items,
  }) {
    return VisitsState(
      createStatus: createStatus ?? this.createStatus,
      getStatus: getStatus ?? this.getStatus,
      createErrorMessage: createErrorMessage,
      getErrorMessage: getErrorMessage,
      items: items ?? this.items,
    );
  }

  @override
  List<Object?> get props => [
        createStatus,
        getStatus,
        createErrorMessage,
        getErrorMessage,
        items,
      ];
}
