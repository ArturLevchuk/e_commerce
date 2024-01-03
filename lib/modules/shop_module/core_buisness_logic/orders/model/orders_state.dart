part of '../vm/orders_controller.dart';

enum OrdersLoadStatus { initial, loading, loaded }

@immutable
class OrdersState {
  final List<OrderItem> orders;
  final OrdersLoadStatus ordersLoadStatus;

  const OrdersState({
    this.orders = const [],
    this.ordersLoadStatus = OrdersLoadStatus.initial,
  });

  OrdersState copyWith({
    List<OrderItem>? orders,
    OrdersLoadStatus? ordersLoadStatus,
  }) {
    return OrdersState(
      orders: orders ?? this.orders,
      ordersLoadStatus: ordersLoadStatus ?? this.ordersLoadStatus,
    );
  }
}
