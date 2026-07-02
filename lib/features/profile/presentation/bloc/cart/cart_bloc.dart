import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garuda_user_app/core/utils/result.dart';
import 'package:garuda_user_app/features/profile/domain/usecases/create_cart_usecase.dart';
import 'package:garuda_user_app/features/profile/domain/usecases/create_payment_usecase.dart';
import 'package:garuda_user_app/features/profile/domain/usecases/get_cart_usecase.dart';
import 'package:garuda_user_app/features/profile/presentation/bloc/cart/cart_event.dart';
import 'package:garuda_user_app/features/profile/presentation/bloc/cart/cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc({
    required CreateCartUseCase createCartUseCase,
    required GetCartUseCase getCartUseCase,
    required CreatePaymentUseCase createPaymentUseCase,
  })  : _createCartUseCase = createCartUseCase,
        _getCartUseCase = getCartUseCase,
        _createPaymentUseCase = createPaymentUseCase,
        super(const CartState()) {
    on<CreateCartRequested>(_onCreateCartRequested);
    on<GetCartRequested>(_onGetCartRequested);
    on<CreatePaymentRequested>(_onCreatePaymentRequested);
  }

  final CreateCartUseCase _createCartUseCase;
  final GetCartUseCase _getCartUseCase;
  final CreatePaymentUseCase _createPaymentUseCase;

  Future<void> _onCreateCartRequested(
    CreateCartRequested event,
    Emitter<CartState> emit,
  ) async {
    emit(state.copyWith(
      createStatus: CreateCartStatus.loading,
      createErrorMessage: null,
    ));

    final result = await _createCartUseCase(event.landIds);

    switch (result) {
      case Success():
        emit(state.copyWith(
          createStatus: CreateCartStatus.success,
          createErrorMessage: null,
        ));
      case Error(failure: final failure):
        emit(state.copyWith(
          createStatus: CreateCartStatus.failure,
          createErrorMessage: failure.message,
        ));
    }
  }

  Future<void> _onGetCartRequested(
    GetCartRequested event,
    Emitter<CartState> emit,
  ) async {
    emit(state.copyWith(
      getStatus: GetCartStatus.loading,
      getErrorMessage: null,
    ));

    final result = await _getCartUseCase();

    switch (result) {
      case Success(data: final items):
        emit(state.copyWith(
          getStatus: GetCartStatus.success,
          items: items,
          getErrorMessage: null,
        ));
      case Error(failure: final failure):
        emit(state.copyWith(
          getStatus: GetCartStatus.failure,
          getErrorMessage: failure.message,
        ));
    }
  }

  Future<void> _onCreatePaymentRequested(
    CreatePaymentRequested event,
    Emitter<CartState> emit,
  ) async {
    emit(state.copyWith(
      paymentStatus: CreatePaymentStatus.loading,
      paymentErrorMessage: null,
    ));

    final result = await _createPaymentUseCase(
      landIds: event.landIds,
      amount: event.amount,
      paymentStatus: 'pending',
    );

    switch (result) {
      case Success():
        emit(state.copyWith(
          paymentStatus: CreatePaymentStatus.success,
          paymentErrorMessage: null,
        ));
      case Error(failure: final failure):
        emit(state.copyWith(
          paymentStatus: CreatePaymentStatus.failure,
          paymentErrorMessage: failure.message,
        ));
    }
  }
}
