import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garuda_user_app/core/utils/result.dart';
import 'package:garuda_user_app/features/search/domain/usecases/get_lands_usecase.dart';
import 'package:garuda_user_app/features/search/presentation/bloc/search_event.dart';
import 'package:garuda_user_app/features/search/presentation/bloc/search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final GetLandsUseCase _getLandsUseCase;

  SearchBloc({required GetLandsUseCase getLandsUseCase})
      : _getLandsUseCase = getLandsUseCase,
        super(const SearchState()) {
    on<GetLandsEvent>(_onGetLands);
  }

  Future<void> _onGetLands(
    GetLandsEvent event,
    Emitter<SearchState> emit,
  ) async {
    emit(state.copyWith(status: SearchStatus.loading));

    final result = await _getLandsUseCase();

    switch (result) {
      case Success(data: final lands):
        emit(state.copyWith(
          status: SearchStatus.success,
          lands: lands,
        ));
      case Error(failure: final f):
        emit(state.copyWith(
          status: SearchStatus.failure,
          errorMessage: f.message,
        ));
    }
  }
}
