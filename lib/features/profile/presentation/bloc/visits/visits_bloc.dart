import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garuda_user_app/core/utils/result.dart';
import 'package:garuda_user_app/features/profile/domain/usecases/create_visit_usecase.dart';
import 'package:garuda_user_app/features/profile/domain/usecases/get_visits_usecase.dart';
import 'package:garuda_user_app/features/profile/presentation/bloc/visits/visits_event.dart';
import 'package:garuda_user_app/features/profile/presentation/bloc/visits/visits_state.dart';

class VisitsBloc extends Bloc<VisitsEvent, VisitsState> {
  VisitsBloc({
    required CreateVisitUseCase createVisitUseCase,
    required GetVisitsUseCase getVisitsUseCase,
  })  : _createVisitUseCase = createVisitUseCase,
        _getVisitsUseCase = getVisitsUseCase,
        super(const VisitsState()) {
    on<CreateVisitRequested>(_onCreateVisitRequested);
    on<GetVisitsRequested>(_onGetVisitsRequested);
  }

  final CreateVisitUseCase _createVisitUseCase;
  final GetVisitsUseCase _getVisitsUseCase;

  Future<void> _onCreateVisitRequested(
    CreateVisitRequested event,
    Emitter<VisitsState> emit,
  ) async {
    emit(state.copyWith(
      createStatus: CreateVisitStatus.loading,
      createErrorMessage: null,
    ));

    final result = await _createVisitUseCase(
      landIds: event.landIds,
      visitDate: event.visitDate,
      time: event.time,
      meetingStatus: 'Scheduled',
    );

    switch (result) {
      case Success():
        emit(state.copyWith(
          createStatus: CreateVisitStatus.success,
          createErrorMessage: null,
        ));
      case Error(failure: final failure):
        emit(state.copyWith(
          createStatus: CreateVisitStatus.failure,
          createErrorMessage: failure.message,
        ));
    }
  }

  Future<void> _onGetVisitsRequested(
    GetVisitsRequested event,
    Emitter<VisitsState> emit,
  ) async {
    emit(state.copyWith(
      getStatus: GetVisitsStatus.loading,
      getErrorMessage: null,
    ));

    final result = await _getVisitsUseCase();

    switch (result) {
      case Success(data: final items):
        emit(state.copyWith(
          getStatus: GetVisitsStatus.success,
          items: items,
          getErrorMessage: null,
        ));
      case Error(failure: final failure):
        emit(state.copyWith(
          getStatus: GetVisitsStatus.failure,
          getErrorMessage: failure.message,
        ));
    }
  }
}
