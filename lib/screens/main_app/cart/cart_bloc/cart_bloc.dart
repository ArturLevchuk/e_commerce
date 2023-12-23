import 'dart:ui';
import 'package:bloc/bloc.dart';
import 'package:e_commerce/constants.dart';
import 'package:e_commerce/repositories/cart_repository.dart';
import 'package:e_commerce/utils/notifications.dart';
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
      emit(state.copyWith(error: err.toString()));
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
      await createCartNotification(state.items.length);
      emit(state.copyWith(items: newItems, error: null));
    } catch (err) {
      emit(state.copyWith(error: err.toString()));
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
      await cancelNotificationsByChannelKey(cartNotificationKey);
      if (newItems.length > 1) {
        await createCartNotification(newItems.length);
      }
      emit(state.copyWith(items: newItems, error: null));
    } catch (err) {
      emit(state.copyWith(error: err.toString()));
    }
  }

  void _onClearCart(
    ClearCart event,
    Emitter<CartState> emit,
  ) async {
    try {
      await cartRepository.clearCart();
      emit(state.copyWith(items: {}, error: null));
    } catch (err) {
      emit(state.copyWith(error: err.toString()));
    }
  }
}
