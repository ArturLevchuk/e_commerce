part of 'cart_bloc.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

class RequestCart extends CartEvent {}

class AddToCart extends CartEvent {
  final String productId;
  final int numOfItem;
  final Color color;

  const AddToCart({
    required this.productId,
    required this.numOfItem,
    required this.color,
  });
}

class RemoveFromCart extends CartEvent {
  final int index;
  const RemoveFromCart({required this.index});
}

class ClearCart extends CartEvent {}
