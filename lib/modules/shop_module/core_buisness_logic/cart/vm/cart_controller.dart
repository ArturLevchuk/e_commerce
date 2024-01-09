import 'dart:developer';

import 'package:flutter/foundation.dart';

import '/constants.dart';
import '/services/abstracts/notification_service.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../../apis/abstract/cart_api.dart';
import '../../../../../apis/models/cart_item.dart';
part '../model/cart_state.dart';

class CartController extends Disposable {
  final CartApi _cartApi;
  final NotificationService _notificationService;
  CartController(this._cartApi, this._notificationService);

  final BehaviorSubject<CartState> _streamController =
      BehaviorSubject.seeded(const CartState());

  Stream<CartState> get stream => _streamController.stream.distinct(
        (previous, current) =>
            previous.cartLoadStatus == current.cartLoadStatus,
      );
  CartState get state => _streamController.value;

  Future<void> fetchAndSetCart({
    required String userId,
    required String authToken,
    bool silentUpdate = false,
  }) async {
    try {
      if (!silentUpdate) {
        _streamController.add(
          state.copyWith(cartLoadStatus: CartLoadStatus.loading),
        );
      }

      final cartItems =
          await _cartApi.fetchAndSetCart(userId: userId, authToken: authToken);

      _streamController.add(state.copyWith(
        items: cartItems,
        cartLoadStatus: CartLoadStatus.loaded,
      ));
    } catch (err) {
      _streamController.add(state.copyWith(
        cartLoadStatus: CartLoadStatus.initial,
      ));
      log(err.toString());
      rethrow;
    }
  }

  Future<void> addToCart({
    required CartItem cartItem,
    required String userId,
    required String authToken,
  }) async {
    try {
      bool productAlreadyInCart = false;
      for (var item in state.items.values) {
        if (item == cartItem) {
          productAlreadyInCart = true;
          break;
        }
      }
      if (productAlreadyInCart) {
        final cartId = state.items.entries
            .firstWhere((element) => element.value == cartItem)
            .key;
        await _cartApi.updateCart(
          cartId: cartId,
          numOfItem: state.items[cartId]!.numOfItem + cartItem.numOfItem,
          userId: userId,
          authToken: authToken,
        );
        final newCartList = Map.of(state.items);
        newCartList[cartId] = cartItem.copyWith(
            numOfItem: state.items[cartId]!.numOfItem + cartItem.numOfItem);
        _streamController.add(state.copyWith(
          items: newCartList,
        ));
      } else {
        final cartId = await _cartApi.addToCart(
          productId: cartItem.productId,
          numOfItem: cartItem.numOfItem,
          color: cartItem.color,
          userId: userId,
          authToken: authToken,
        );
        _streamController.add(state.copyWith(
          items: Map.from(state.items)..[cartId] = cartItem,
        ));
      }

      await _notificationService.cancelNotificationsByChannelKey(
          channelKey: cartNotificationKey);
      await _notificationService.createNotification(
        channelKey: cartNotificationKey,
        title: 'You have pending purchases🛒🛒🛒',
        body:
            'There are ${state.items.length} items in your cart. Don\'t wait, order!',
        timeOut: const Duration(seconds: 60),
      );
    } catch (err) {
      log(err.toString());
      rethrow;
    }
  }

  Future<void> removeFromCart({
    required String cartId,
    required String userId,
    required String authToken,
  }) async {
    try {
      await _cartApi.removeFromCart(
        authToken: authToken,
        userId: userId,
        cartId: cartId,
      );
      _streamController.add(state.copyWith(
        items: Map.of(state.items)..remove(cartId),
      ));
      await _notificationService.cancelNotificationsByChannelKey(
          channelKey: cartNotificationKey);
    } catch (err) {
      log(err.toString());
      rethrow;
    }
  }

  Future<void> clearCart({
    required String userId,
    required String authToken,
  }) async {
    try {
      await _cartApi.clearCart(
        authToken: authToken,
        userId: userId,
      );
      _streamController.add(state.copyWith(
        items: {},
      ));
      await _notificationService.cancelNotificationsByChannelKey(
          channelKey: cartNotificationKey);
    } catch (err) {
      log(err.toString());
      rethrow;
    }
  }

  @override
  void dispose() {
    _streamController.close();
  }
}
