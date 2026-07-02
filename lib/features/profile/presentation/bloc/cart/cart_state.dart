import 'package:equatable/equatable.dart';
import 'package:garuda_user_app/features/profile/domain/entities/cart_item_entity.dart';

enum CreateCartStatus { initial, loading, success, failure }
enum GetCartStatus { initial, loading, success, failure }
enum CreatePaymentStatus { initial, loading, success, failure }

class CartState extends Equatable {
  const CartState({
    this.createStatus = CreateCartStatus.initial,
    this.getStatus = GetCartStatus.initial,
    this.paymentStatus = CreatePaymentStatus.initial,
    this.createErrorMessage,
    this.getErrorMessage,
    this.paymentErrorMessage,
    this.items = const <CartItemEntity>[],
  });

  final CreateCartStatus createStatus;
  final GetCartStatus getStatus;
  final CreatePaymentStatus paymentStatus;
  final String? createErrorMessage;
  final String? getErrorMessage;
  final String? paymentErrorMessage;
  final List<CartItemEntity> items;

  CartState copyWith({
    CreateCartStatus? createStatus,
    GetCartStatus? getStatus,
    CreatePaymentStatus? paymentStatus,
    String? createErrorMessage,
    String? getErrorMessage,
    String? paymentErrorMessage,
    List<CartItemEntity>? items,
  }) {
    return CartState(
      createStatus: createStatus ?? this.createStatus,
      getStatus: getStatus ?? this.getStatus,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      createErrorMessage: createErrorMessage,
      getErrorMessage: getErrorMessage,
      paymentErrorMessage: paymentErrorMessage,
      items: items ?? this.items,
    );
  }

  @override
  List<Object?> get props => [
        createStatus,
        getStatus,
        paymentStatus,
        createErrorMessage,
        getErrorMessage,
        paymentErrorMessage,
        items,
      ];
}
