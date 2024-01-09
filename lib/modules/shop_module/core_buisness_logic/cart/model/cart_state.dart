// ignore_for_file: hash_and_equals

part of '../vm/cart_controller.dart';

enum CartLoadStatus { initial, loading, loaded }

@immutable
class CartState {
  final Map<String, CartItem> items;
  final CartLoadStatus cartLoadStatus;
  
  const CartState({
    this.items = const {},
    this.cartLoadStatus = CartLoadStatus.initial,
  });

  CartState copyWith({
    Map<String, CartItem>? items,
    CartLoadStatus? cartLoadStatus,
  }) {
    return CartState(
      items: items ?? this.items,
      cartLoadStatus: cartLoadStatus ?? this.cartLoadStatus,
    );
  }

  @override
  bool operator == (Object other) {
    return other is CartState && mapEquals(items, other.items) && cartLoadStatus == other.cartLoadStatus;
  }
  
}
