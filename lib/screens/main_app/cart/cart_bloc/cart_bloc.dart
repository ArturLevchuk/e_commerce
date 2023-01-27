import 'dart:ui';
import 'package:bloc/bloc.dart';
import 'package:e_commerce/repositories/cart_repository.dart';
import 'package:equatable/equatable.dart';
import '../../../../repositories/models/cart_item.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc({required this.cartRepository})
      : super(const CartState(cartLoadStatus: CartLoadStatus.initial)) {
    on<RequestCart>(_onRequestCart);
    on<AddToCart>(_onAddToCart);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<ClearCart>(_onClearCart);
  }
  final CartRepository cartRepository;

  void _onRequestCart(
    RequestCart event,
    Emitter<CartState> emit,
  ) async {
    try {
      emit(state.copyWith(cartLoadStatus: CartLoadStatus.loading));
      final items = await cartRepository.fetchAndSetCart();
      emit(
        state.copyWith(items: items, cartLoadStatus: CartLoadStatus.loaded),
      );
    } catch (err) {
      rethrow;
    }
  }

  void _onAddToCart(
    AddToCart event,
    Emitter<CartState> emit,
  ) async {
    try {
      final newItems = await cartRepository.addToCart(
        productId: event.productId,
        numOfItem: event.numOfItem,
        color: event.color,
        items: state.items,
      );
      emit(state.copyWith(items: newItems));
    } catch (err) {
      rethrow;
    }
  }

  void _onRemoveFromCart(
    RemoveFromCart event,
    Emitter<CartState> emit,
  ) async {
    try {
      final newItems = await cartRepository.removeCartItem(
        index: event.index,
        items: state.items,
      );
      emit(state.copyWith(items: newItems));
    } catch (err) {
      rethrow;
    }
  }

  void _onClearCart(
    ClearCart event,
    Emitter<CartState> emit,
  ) async {
    try {
      await cartRepository.clearCart();
      emit(state.copyWith(items: {}));
    } catch (err) {
      rethrow;
    }
  }
}
