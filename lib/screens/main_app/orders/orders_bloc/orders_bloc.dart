import 'package:bloc/bloc.dart';
import 'package:e_commerce/repositories/orders_repository.dart';

import '../../../../repositories/models/cart_item.dart';
import '../../../../repositories/models/order_item.dart';

part 'orders_event.dart';
part 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  OrdersBloc(this.ordersRepository)
      : super(OrdersState(ordersLoadStatus: OrdersLoadStatus.initial)) {
    on<RequestOrders>(_onRequestOrders);
    on<AddOrder>(_onAddOrder);
    on<CancelOrder>(_onCancelOrder);
  }

  final OrdersRepository ordersRepository;

  void _onRequestOrders(
    RequestOrders event,
    Emitter<OrdersState> emit,
  ) async {
    try {
      emit(state.copyWith(ordersLoadStatus: OrdersLoadStatus.loading));
      final orderItems = await ordersRepository.fetchAndSetOrders();
      emit(state.copyWith(
          orders: orderItems, ordersLoadStatus: OrdersLoadStatus.loaded));
    } catch (err) {
      emit(state.copyWith(error: err.toString()));
    }
  }

  void _onAddOrder(
    AddOrder event,
    Emitter<OrdersState> emit,
  ) async {
    try {
      await ordersRepository.addOrder(
        cartProducts: event.cartProducts,
        totalPrice: event.totalPrice,
        arrivePlace: event.arrivePlace,
        payment: event.payment,
      );
      emit(state.copyWith(ordersLoadStatus: OrdersLoadStatus.initial));
    } catch (err) {
      emit(state.copyWith(error: err.toString()));
    }
  }

  void _onCancelOrder(
    CancelOrder event,
    Emitter<OrdersState> emit,
  ) async {
    try {
      final newOrdersList = await ordersRepository.deleteOrder(
        orderId: event.orderId,
        orders: state.orders,
      );
      emit(state.copyWith(orders: newOrdersList));
    } catch (err) {
      emit(state.copyWith(error: err.toString()));
    }
  }
}
