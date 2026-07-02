import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garuda_user_app/core/utils/result.dart';
import 'package:garuda_user_app/features/profile/domain/usecases/create_final_usecase.dart';
import 'package:garuda_user_app/features/profile/domain/usecases/create_shortlist_usecase.dart';
import 'package:garuda_user_app/features/profile/domain/usecases/delete_final_usecase.dart';
import 'package:garuda_user_app/features/profile/domain/usecases/delete_shortlist_usecase.dart';
import 'package:garuda_user_app/features/profile/domain/usecases/get_finals_usecase.dart';
import 'package:garuda_user_app/features/profile/domain/usecases/get_shortlists_usecase.dart';
import 'package:garuda_user_app/features/profile/presentation/bloc/shortlist/shortlist_event.dart';
import 'package:garuda_user_app/features/profile/presentation/bloc/shortlist/shortlist_state.dart';

class ShortlistBloc extends Bloc<ShortlistEvent, ShortlistState> {
  ShortlistBloc({
    required GetShortlistsUseCase getShortlistsUseCase,
    required GetFinalsUseCase getFinalsUseCase,
    required CreateShortlistUseCase createShortlistUseCase,
    required DeleteShortlistUseCase deleteShortlistUseCase,
    required CreateFinalUseCase createFinalUseCase,
    required DeleteFinalUseCase deleteFinalUseCase,
  })  : _getShortlistsUseCase = getShortlistsUseCase,
        _getFinalsUseCase = getFinalsUseCase,
        _createShortlistUseCase = createShortlistUseCase,
        _deleteShortlistUseCase = deleteShortlistUseCase,
        _createFinalUseCase = createFinalUseCase,
        _deleteFinalUseCase = deleteFinalUseCase,
        super(const ShortlistState()) {
    on<GetShortlistsRequested>(_onGetShortlistsRequested);
    on<GetFinalsRequested>(_onGetFinalsRequested);
    on<CreateShortlistRequested>(_onCreateShortlistRequested);
    on<DeleteShortlistRequested>(_onDeleteShortlistRequested);
    on<CreateFinalRequested>(_onCreateFinalRequested);
    on<DeleteFinalRequested>(_onDeleteFinalRequested);
  }

  final GetShortlistsUseCase _getShortlistsUseCase;
  final GetFinalsUseCase _getFinalsUseCase;
  final CreateShortlistUseCase _createShortlistUseCase;
  final DeleteShortlistUseCase _deleteShortlistUseCase;
  final CreateFinalUseCase _createFinalUseCase;
  final DeleteFinalUseCase _deleteFinalUseCase;

  Future<void> _onGetShortlistsRequested(
    GetShortlistsRequested event,
    Emitter<ShortlistState> emit,
  ) async {
    emit(state.copyWith(
      getShortlistsStatus: GetShortlistsStatus.loading,
      shortlistItemsErrorMessage: null,
    ));

    final result = await _getShortlistsUseCase();

    switch (result) {
      case Success(data: final shortlistItems):
        emit(state.copyWith(
          getShortlistsStatus: GetShortlistsStatus.success,
          shortlistItems: shortlistItems,
          shortlistedLandIds:
              shortlistItems.map((item) => item.landId).toList(),
          shortlistItemsErrorMessage: null,
        ));
      case Error(failure: final failure):
        emit(state.copyWith(
          getShortlistsStatus: GetShortlistsStatus.failure,
          shortlistItemsErrorMessage: failure.message,
        ));
    }
  }

  Future<void> _onGetFinalsRequested(
    GetFinalsRequested event,
    Emitter<ShortlistState> emit,
  ) async {
    emit(state.copyWith(
      getFinalsStatus: GetFinalsStatus.loading,
      finalItemsErrorMessage: null,
    ));

    final result = await _getFinalsUseCase();

    switch (result) {
      case Success(data: final finalItems):
        emit(state.copyWith(
          getFinalsStatus: GetFinalsStatus.success,
          finalItems: finalItems,
          finalizedLandIds: finalItems.map((item) => item.landId).toList(),
          finalItemsErrorMessage: null,
        ));
      case Error(failure: final failure):
        emit(state.copyWith(
          getFinalsStatus: GetFinalsStatus.failure,
          finalItemsErrorMessage: failure.message,
        ));
    }
  }

  Future<void> _onCreateShortlistRequested(
    CreateShortlistRequested event,
    Emitter<ShortlistState> emit,
  ) async {
    final isAlreadyLoading = state.shortlistStatus ==
            CreateShortlistStatus.loading &&
        state.activeShortlistLandId == event.landId;
    if (isAlreadyLoading) {
      return;
    }

    emit(state.copyWith(
      shortlistStatus: CreateShortlistStatus.loading,
      shortlistMessage: null,
      activeShortlistLandId: event.landId,
    ));

    final result = await _createShortlistUseCase(landId: event.landId);

    switch (result) {
      case Success(data: final message):
        final updatedShortlistedIds = <int>{
          ...state.shortlistedLandIds,
          event.landId,
        }.toList();
        emit(state.copyWith(
          shortlistStatus: CreateShortlistStatus.success,
          shortlistMessage: message,
          activeShortlistLandId: event.landId,
          shortlistedLandIds: updatedShortlistedIds,
        ));
        add(const GetShortlistsRequested());
      case Error(failure: final failure):
        emit(state.copyWith(
          shortlistStatus: CreateShortlistStatus.failure,
          shortlistMessage: failure.message,
          activeShortlistLandId: event.landId,
        ));
    }
  }

  Future<void> _onDeleteShortlistRequested(
    DeleteShortlistRequested event,
    Emitter<ShortlistState> emit,
  ) async {
    final isAlreadyLoading =
        state.deleteShortlistStatus == DeleteShortlistStatus.loading &&
            state.activeDeleteShortlistLandId == event.landId;
    if (isAlreadyLoading) {
      return;
    }

    emit(state.copyWith(
      deleteShortlistStatus: DeleteShortlistStatus.loading,
      deleteShortlistMessage: null,
      activeDeleteShortlistLandId: event.landId,
    ));

    final result = await _deleteShortlistUseCase(landId: event.landId);

    switch (result) {
      case Success(data: final message):
        final updatedShortlistedIds = state.shortlistedLandIds
            .where((id) => id != event.landId)
            .toList();
        emit(state.copyWith(
          deleteShortlistStatus: DeleteShortlistStatus.success,
          deleteShortlistMessage: message,
          activeDeleteShortlistLandId: event.landId,
          shortlistedLandIds: updatedShortlistedIds,
          shortlistItems: state.shortlistItems
              .where((item) => item.landId != event.landId)
              .toList(),
          finalizedLandIds:
              state.finalizedLandIds.where((id) => id != event.landId).toList(),
        ));
      case Error(failure: final failure):
        emit(state.copyWith(
          deleteShortlistStatus: DeleteShortlistStatus.failure,
          deleteShortlistMessage: failure.message,
          activeDeleteShortlistLandId: event.landId,
        ));
    }
  }

  Future<void> _onCreateFinalRequested(
    CreateFinalRequested event,
    Emitter<ShortlistState> emit,
  ) async {
    final isAlreadyLoading = state.createFinalStatus ==
            CreateFinalStatus.loading &&
        state.activeFinalLandId == event.landId;
    if (isAlreadyLoading) {
      return;
    }

    emit(state.copyWith(
      createFinalStatus: CreateFinalStatus.loading,
      finalMessage: null,
      activeFinalLandId: event.landId,
    ));

    final result = await _createFinalUseCase(landId: event.landId);

    switch (result) {
      case Success(data: final message):
        final updatedFinalizedIds = <int>{
          ...state.finalizedLandIds,
          event.landId,
        }.toList();
        emit(state.copyWith(
          createFinalStatus: CreateFinalStatus.success,
          finalMessage: message,
          activeFinalLandId: event.landId,
          finalizedLandIds: updatedFinalizedIds,
        ));
        add(const GetFinalsRequested());
      case Error(failure: final failure):
        emit(state.copyWith(
          createFinalStatus: CreateFinalStatus.failure,
          finalMessage: failure.message,
          activeFinalLandId: event.landId,
        ));
    }
  }

  Future<void> _onDeleteFinalRequested(
    DeleteFinalRequested event,
    Emitter<ShortlistState> emit,
  ) async {
    final isAlreadyLoading = state.deleteFinalStatus ==
            DeleteFinalStatus.loading &&
        state.activeDeleteFinalLandId == event.landId;
    if (isAlreadyLoading) {
      return;
    }

    emit(state.copyWith(
      deleteFinalStatus: DeleteFinalStatus.loading,
      deleteFinalMessage: null,
      activeDeleteFinalLandId: event.landId,
    ));

    final result = await _deleteFinalUseCase(landId: event.landId);

    switch (result) {
      case Success(data: final message):
        emit(state.copyWith(
          deleteFinalStatus: DeleteFinalStatus.success,
          deleteFinalMessage: message,
          activeDeleteFinalLandId: event.landId,
          finalItems: state.finalItems
              .where((item) => item.landId != event.landId)
              .toList(),
          finalizedLandIds:
              state.finalizedLandIds.where((id) => id != event.landId).toList(),
        ));
      case Error(failure: final failure):
        emit(state.copyWith(
          deleteFinalStatus: DeleteFinalStatus.failure,
          deleteFinalMessage: failure.message,
          activeDeleteFinalLandId: event.landId,
        ));
    }
  }
}
