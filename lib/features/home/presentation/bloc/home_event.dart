import 'package:equatable/equatable.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => <Object?>[];
}

final class HomeRequested extends HomeEvent {
  const HomeRequested();
}
