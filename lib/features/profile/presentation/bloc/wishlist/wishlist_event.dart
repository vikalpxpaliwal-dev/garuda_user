import 'package:equatable/equatable.dart';

sealed class WishlistEvent extends Equatable {
  const WishlistEvent();

  @override
  List<Object?> get props => [];
}

class WishlistRequested extends WishlistEvent {
  const WishlistRequested();
}
