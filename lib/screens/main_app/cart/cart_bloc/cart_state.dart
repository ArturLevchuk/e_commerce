part of 'cart_bloc.dart';

enum CartLoadStatus { initial, loading, loaded }

class CartState {
  final Map<String, CartItem> items;
  final CartLoadStatus cartLoadStatus;
  final String? error;
  const CartState(
      {this.items = const {}, required this.cartLoadStatus, this.error});

  CartState copyWith(
      {Map<String, CartItem>? items,
      CartLoadStatus? cartLoadStatus,
      String? error}) {
    return CartState(
      items: items ?? this.items,
      cartLoadStatus: cartLoadStatus ?? this.cartLoadStatus,
      error: error,
    );
  }
}
