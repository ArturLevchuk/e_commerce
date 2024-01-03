import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../../apis/abstract/orders_api.dart';
import '../../../../../apis/models/cart_item.dart';
import '../../../../../apis/models/order_item.dart';
part '../model/orders_state.dart';

class OrdersController {
  final OrdersApi _ordersApi;

  OrdersController(this._ordersApi);

  final BehaviorSubject<OrdersState> _streamController =
      BehaviorSubject.seeded(const OrdersState());
  Stream<OrdersState> get stream => _streamController.stream;
  OrdersState get state => _streamController.value;

  Future<void> fetchAndSetOrders({
    required String userId,
    required String authToken,
  }) async {
    try {
      _streamController.add(
        state.copyWith(ordersLoadStatus: OrdersLoadStatus.loading),
      );
      final ordersList = await _ordersApi.fetchAndSetOrders(
        userId: userId,
        authToken: authToken,
      );
      _streamController.add(
        state.copyWith(
          orders: ordersList,
          ordersLoadStatus: OrdersLoadStatus.loaded,
        ),
      );
    } catch (err) {
      log(err.toString());
      _streamController.add(state.copyWith(ordersLoadStatus: OrdersLoadStatus.initial));
      rethrow;
    }
  }

  Future<void> addOrder({
    required List<CartItem> cartProducts,
    required double totalPrice,
    required String arrivePlace,
    required String payment,
    required String userId,
    required String authToken,
  }) async {
    try {
      final DateTime timeCode = DateTime.now();
      final id = await _ordersApi.addOrder(
        cartProducts: cartProducts,
        totalPrice: totalPrice,
        arrivePlace: arrivePlace,
        payment: payment,
        timeCode: timeCode,
        userId: userId,
        authToken: authToken,
      );
      _streamController.add(
        state.copyWith(
          orders: List.of(state.orders)
            ..add(
              OrderItem(
                id: id,
                products: cartProducts,
                totalPrice: totalPrice,
                payment: payment,
                arrivePlace: arrivePlace,
                dateTime: timeCode,
              ),
            ),
        ),
      );
    } catch (err) {
      log(err.toString());
      rethrow;
    }
  }

  Future<void> cancelOrder({
    required String orderId,
    required String userId,
    required String authToken,
  }) async {
    try {
      await _ordersApi.cancelOrder(
        orderId: orderId,
        userId: userId,
        authToken: authToken,
      );
      _streamController.add(
        state.copyWith(
          orders: List.of(state.orders)
            ..removeWhere((element) => element.id == orderId),
        ),
      );
    } catch (err) {
      log(err.toString());
      rethrow;
    }
  }
}
