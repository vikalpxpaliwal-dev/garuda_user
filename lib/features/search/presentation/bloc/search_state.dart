import 'package:equatable/equatable.dart';
import 'package:garuda_user_app/features/search/domain/entities/land_entity.dart';

enum SearchStatus { initial, loading, success, failure }

class SearchState extends Equatable {
  final SearchStatus status;
  final List<LandEntity> lands;
  final String? errorMessage;

  const SearchState({
    this.status = SearchStatus.initial,
    this.lands = const [],
    this.errorMessage,
  });

  SearchState copyWith({
    SearchStatus? status,
    List<LandEntity>? lands,
    String? errorMessage,
  }) {
    return SearchState(
      status: status ?? this.status,
      lands: lands ?? this.lands,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, lands, errorMessage];
}
