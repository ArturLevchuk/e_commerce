import '/apis/models/order_item.dart';

import '../models/cart_item.dart';

abstract interface class OrdersApi {
  Future<List<OrderItem>> fetchAndSetOrders({
    required String userId,
    required String authToken,
  });

  Future<String> addOrder({
    required List<CartItem> cartProducts,
    required double totalPrice,
    required String arrivePlace,
    required String payment,
    required DateTime timeCode,
    required String userId,
    required String authToken,
  });

  Future<void> cancelOrder({
    required String orderId,
    required String userId,
    required String authToken,
  });
}
