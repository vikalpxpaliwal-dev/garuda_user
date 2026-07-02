import 'package:equatable/equatable.dart';

sealed class ShortlistEvent extends Equatable {
  const ShortlistEvent();

  @override
  List<Object?> get props => [];
}

class GetShortlistsRequested extends ShortlistEvent {
  const GetShortlistsRequested();
}

class GetFinalsRequested extends ShortlistEvent {
  const GetFinalsRequested();
}

class CreateShortlistRequested extends ShortlistEvent {
  const CreateShortlistRequested({required this.landId});

  final int landId;

  @override
  List<Object?> get props => [landId];
}

class DeleteShortlistRequested extends ShortlistEvent {
  const DeleteShortlistRequested({required this.landId});

  final int landId;

  @override
  List<Object?> get props => [landId];
}

class CreateFinalRequested extends ShortlistEvent {
  const CreateFinalRequested({required this.landId});

  final int landId;

  @override
  List<Object?> get props => [landId];
}

class DeleteFinalRequested extends ShortlistEvent {
  const DeleteFinalRequested({required this.landId});

  final int landId;

  @override
  List<Object?> get props => [landId];
}
