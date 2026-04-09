import 'package:equatable/equatable.dart';

sealed class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}

class GetLandsEvent extends SearchEvent {
  const GetLandsEvent();
}
