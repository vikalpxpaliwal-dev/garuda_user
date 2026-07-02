import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garuda_user_app/core/utils/result.dart';
import 'package:garuda_user_app/features/profile/domain/usecases/create_availability_usecase.dart';
import 'package:garuda_user_app/features/profile/domain/usecases/get_availability_usecase.dart';
import 'package:garuda_user_app/features/profile/presentation/bloc/availability/availability_event.dart';
import 'package:garuda_user_app/features/profile/presentation/bloc/availability/availability_state.dart';

class AvailabilityBloc extends Bloc<AvailabilityEvent, AvailabilityState> {
  AvailabilityBloc({
    required CreateAvailabilityUseCase createAvailabilityUseCase,
    required GetAvailabilityUseCase getAvailabilityUseCase,
  })  : _createAvailabilityUseCase = createAvailabilityUseCase,
        _getAvailabilityUseCase = getAvailabilityUseCase,
        super(const AvailabilityState()) {
    on<CreateAvailabilityRequested>(_onCreateAvailabilityRequested);
    on<GetAvailabilitiesRequested>(_onGetAvailabilitiesRequested);
  }

  final CreateAvailabilityUseCase _createAvailabilityUseCase;
  final GetAvailabilityUseCase _getAvailabilityUseCase;

  Future<void> _onCreateAvailabilityRequested(
    CreateAvailabilityRequested event,
    Emitter<AvailabilityState> emit,
  ) async {
    emit(state.copyWith(
      createStatus: CreateAvailabilityStatus.loading,
      errorMessage: null,
    ));

    final result = await _createAvailabilityUseCase(event.landIds);

    switch (result) {
      case Success():
        emit(state.copyWith(
          createStatus: CreateAvailabilityStatus.success,
          errorMessage: null,
        ));
      case Error(failure: final failure):
        emit(state.copyWith(
          createStatus: CreateAvailabilityStatus.failure,
          errorMessage: failure.message,
        ));
    }
  }

  Future<void> _onGetAvailabilitiesRequested(
    GetAvailabilitiesRequested event,
    Emitter<AvailabilityState> emit,
  ) async {
    emit(state.copyWith(
      getStatus: GetAvailabilityStatus.loading,
      errorMessage: null,
    ));

    final result = await _getAvailabilityUseCase();

    switch (result) {
      case Success(data: final items):
        emit(state.copyWith(
          getStatus: GetAvailabilityStatus.success,
          items: items,
          errorMessage: null,
        ));
      case Error(failure: final failure):
        emit(state.copyWith(
          getStatus: GetAvailabilityStatus.failure,
          errorMessage: failure.message,
        ));
    }
  }
}
