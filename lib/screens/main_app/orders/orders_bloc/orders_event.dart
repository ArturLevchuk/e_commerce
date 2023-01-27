part of 'orders_bloc.dart';

abstract class OrdersEvent {
  const OrdersEvent();
}

class RequestOrders extends OrdersEvent {}

class AddOrder extends OrdersEvent {
  final List<CartItem> cartProducts;
  final double totalPrice;
  final String arrivePlace, payment;

  const AddOrder({
    required this.cartProducts,
    required this.totalPrice,
    required this.arrivePlace,
    required this.payment,
  });
}

class CancelOrder extends OrdersEvent {
  final String orderId;

  CancelOrder(this.orderId);
}
