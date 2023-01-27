part of 'orders_bloc.dart';

enum OrdersLoadStatus { initial, loading, loaded }

class OrdersState {
  final List<OrderItem> orders;
  final OrdersLoadStatus ordersLoadStatus;

  OrdersState({this.orders = const [], required this.ordersLoadStatus});

  OrdersState copyWith(
      {List<OrderItem>? orders, OrdersLoadStatus? ordersLoadStatus}) {
    return OrdersState(
      orders: orders ?? this.orders,
      ordersLoadStatus: ordersLoadStatus ?? this.ordersLoadStatus,
    );
  }
}
