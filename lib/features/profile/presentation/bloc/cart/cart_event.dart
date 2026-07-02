import 'package:equatable/equatable.dart';

sealed class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

class CreateCartRequested extends CartEvent {
  const CreateCartRequested({required this.landIds});

  final List<int> landIds;

  @override
  List<Object?> get props => [landIds];
}

class GetCartRequested extends CartEvent {
  const GetCartRequested();
}

class CreatePaymentRequested extends CartEvent {
  const CreatePaymentRequested({
    required this.landIds,
    required this.amount,
  });

  final List<int> landIds;
  final int amount;

  @override
  List<Object?> get props => [landIds, amount];
}
