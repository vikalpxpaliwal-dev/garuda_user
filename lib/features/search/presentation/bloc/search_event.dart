import 'package:equatable/equatable.dart';

sealed class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}

class GetLandsEvent extends SearchEvent {
  const GetLandsEvent();
}

class AddToWishlistEvent extends SearchEvent {
  const AddToWishlistEvent({required this.landId});

  final int landId;

  @override
  List<Object?> get props => [landId];
}

class AddSelectedToWishlistEvent extends SearchEvent {
  const AddSelectedToWishlistEvent({required this.landIds});

  final List<int> landIds;

  @override
  List<Object?> get props => [landIds];
}
