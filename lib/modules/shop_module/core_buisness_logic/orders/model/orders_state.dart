// ignore_for_file: hash_and_equals

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

  @override
  bool operator == (Object other) {
    return other is OrdersState && listEquals(orders, other.orders) && ordersLoadStatus == other.ordersLoadStatus;
  }

}
