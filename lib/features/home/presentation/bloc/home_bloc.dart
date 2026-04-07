import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garuda_user_app/core/constants/app_strings.dart';
import 'package:garuda_user_app/core/utils/result.dart';
import 'package:garuda_user_app/features/home/domain/entities/home_dashboard.dart';
import 'package:garuda_user_app/features/home/domain/usecases/get_home_dashboard.dart';
import 'package:garuda_user_app/features/home/presentation/bloc/home_event.dart';
import 'package:garuda_user_app/features/home/presentation/bloc/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({required GetHomeDashboard getHomeDashboard})
    : _getHomeDashboard = getHomeDashboard,
      super(const HomeState()) {
    on<HomeRequested>(_onHomeRequested);
  }

  final GetHomeDashboard _getHomeDashboard;

  Future<void> _onHomeRequested(
    HomeRequested event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(status: HomeStatus.loading, errorMessage: null));

    final result = await _getHomeDashboard();

    switch (result) {
      case Success<HomeDashboard>(:final data):
        emit(
          state.copyWith(
            status: HomeStatus.success,
            dashboard: data,
            errorMessage: null,
          ),
        );
      case Error<HomeDashboard>(:final failure):
        emit(
          state.copyWith(
            status: HomeStatus.failure,
            errorMessage: failure.message.isEmpty
                ? AppStrings.unexpectedError
                : failure.message,
          ),
        );
    }
  }
}
