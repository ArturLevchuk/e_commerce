part of 'cart_bloc.dart';

enum CartLoadStatus { initial, loading, loaded }

class CartState {
  final Map<String, CartItem> items;
  final CartLoadStatus cartLoadStatus;
  const CartState({this.items = const {}, required this.cartLoadStatus});

  CartState copyWith(
      {Map<String, CartItem>? items, CartLoadStatus? cartLoadStatus}) {
    return CartState(
      items: items ?? this.items,
      cartLoadStatus: cartLoadStatus ?? this.cartLoadStatus,
    );
  }
}
