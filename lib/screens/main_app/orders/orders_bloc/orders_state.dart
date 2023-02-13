part of 'orders_bloc.dart';

enum OrdersLoadStatus { initial, loading, loaded }

class OrdersState {
  final List<OrderItem> orders;
  final OrdersLoadStatus ordersLoadStatus;
  final String? error;

  OrdersState({this.orders = const [], required this.ordersLoadStatus,this.error});

  OrdersState copyWith(
      {List<OrderItem>? orders, OrdersLoadStatus? ordersLoadStatus, String? error}) {
    return OrdersState(
      orders: orders ?? this.orders,
      ordersLoadStatus: ordersLoadStatus ?? this.ordersLoadStatus,
      error: error,
    );
  }
}
