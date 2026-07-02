import 'package:equatable/equatable.dart';
import 'package:garuda_user_app/features/profile/domain/entities/shortlist_item_entity.dart';

enum GetShortlistsStatus { initial, loading, success, failure }
enum GetFinalsStatus { initial, loading, success, failure }
enum CreateShortlistStatus { initial, loading, success, failure }
enum DeleteShortlistStatus { initial, loading, success, failure }
enum CreateFinalStatus { initial, loading, success, failure }
enum DeleteFinalStatus { initial, loading, success, failure }

class ShortlistState extends Equatable {
  const ShortlistState({
    this.getShortlistsStatus = GetShortlistsStatus.initial,
    this.shortlistItems = const <ShortlistItemEntity>[],
    this.shortlistItemsErrorMessage,
    this.getFinalsStatus = GetFinalsStatus.initial,
    this.finalItems = const <ShortlistItemEntity>[],
    this.finalItemsErrorMessage,
    this.shortlistStatus = CreateShortlistStatus.initial,
    this.shortlistMessage,
    this.activeShortlistLandId,
    this.shortlistedLandIds = const <int>[],
    this.deleteShortlistStatus = DeleteShortlistStatus.initial,
    this.deleteShortlistMessage,
    this.activeDeleteShortlistLandId,
    this.createFinalStatus = CreateFinalStatus.initial,
    this.finalMessage,
    this.activeFinalLandId,
    this.finalizedLandIds = const <int>[],
    this.deleteFinalStatus = DeleteFinalStatus.initial,
    this.deleteFinalMessage,
    this.activeDeleteFinalLandId,
  });

  final GetShortlistsStatus getShortlistsStatus;
  final List<ShortlistItemEntity> shortlistItems;
  final String? shortlistItemsErrorMessage;
  final GetFinalsStatus getFinalsStatus;
  final List<ShortlistItemEntity> finalItems;
  final String? finalItemsErrorMessage;
  final CreateShortlistStatus shortlistStatus;
  final String? shortlistMessage;
  final int? activeShortlistLandId;
  final List<int> shortlistedLandIds;
  final DeleteShortlistStatus deleteShortlistStatus;
  final String? deleteShortlistMessage;
  final int? activeDeleteShortlistLandId;
  final CreateFinalStatus createFinalStatus;
  final String? finalMessage;
  final int? activeFinalLandId;
  final List<int> finalizedLandIds;
  final DeleteFinalStatus deleteFinalStatus;
  final String? deleteFinalMessage;
  final int? activeDeleteFinalLandId;

  ShortlistState copyWith({
    GetShortlistsStatus? getShortlistsStatus,
    List<ShortlistItemEntity>? shortlistItems,
    String? shortlistItemsErrorMessage,
    GetFinalsStatus? getFinalsStatus,
    List<ShortlistItemEntity>? finalItems,
    String? finalItemsErrorMessage,
    CreateShortlistStatus? shortlistStatus,
    String? shortlistMessage,
    int? activeShortlistLandId,
    List<int>? shortlistedLandIds,
    DeleteShortlistStatus? deleteShortlistStatus,
    String? deleteShortlistMessage,
    int? activeDeleteShortlistLandId,
    CreateFinalStatus? createFinalStatus,
    String? finalMessage,
    int? activeFinalLandId,
    List<int>? finalizedLandIds,
    DeleteFinalStatus? deleteFinalStatus,
    String? deleteFinalMessage,
    int? activeDeleteFinalLandId,
  }) {
    return ShortlistState(
      getShortlistsStatus: getShortlistsStatus ?? this.getShortlistsStatus,
      shortlistItems: shortlistItems ?? this.shortlistItems,
      shortlistItemsErrorMessage: shortlistItemsErrorMessage,
      getFinalsStatus: getFinalsStatus ?? this.getFinalsStatus,
      finalItems: finalItems ?? this.finalItems,
      finalItemsErrorMessage: finalItemsErrorMessage,
      shortlistStatus: shortlistStatus ?? this.shortlistStatus,
      shortlistMessage: shortlistMessage,
      activeShortlistLandId: activeShortlistLandId,
      shortlistedLandIds: shortlistedLandIds ?? this.shortlistedLandIds,
      deleteShortlistStatus:
          deleteShortlistStatus ?? this.deleteShortlistStatus,
      deleteShortlistMessage: deleteShortlistMessage,
      activeDeleteShortlistLandId: activeDeleteShortlistLandId,
      createFinalStatus: createFinalStatus ?? this.createFinalStatus,
      finalMessage: finalMessage,
      activeFinalLandId: activeFinalLandId,
      finalizedLandIds: finalizedLandIds ?? this.finalizedLandIds,
      deleteFinalStatus: deleteFinalStatus ?? this.deleteFinalStatus,
      deleteFinalMessage: deleteFinalMessage,
      activeDeleteFinalLandId: activeDeleteFinalLandId,
    );
  }

  @override
  List<Object?> get props => [
        getShortlistsStatus,
        shortlistItems,
        shortlistItemsErrorMessage,
        getFinalsStatus,
        finalItems,
        finalItemsErrorMessage,
        shortlistStatus,
        shortlistMessage,
        activeShortlistLandId,
        shortlistedLandIds,
        deleteShortlistStatus,
        deleteShortlistMessage,
        activeDeleteShortlistLandId,
        createFinalStatus,
        finalMessage,
        activeFinalLandId,
        finalizedLandIds,
        deleteFinalStatus,
        deleteFinalMessage,
        activeDeleteFinalLandId,
      ];
}
