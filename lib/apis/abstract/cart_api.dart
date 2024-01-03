import 'dart:ui';

import '../models/cart_item.dart';

abstract interface class CartApi {
  Future<Map<String, CartItem>> fetchAndSetCart({
    required String userId,
    required String authToken,
  });

  Future<String> addToCart({
    required String productId,
    required int numOfItem,
    required Color color,
    required String userId,
    required String authToken,
  });

  Future<void> updateCart({
    required String cartId,
    required int numOfItem,
    required String userId,
    required String authToken,
  });

  Future<void> removeFromCart({
    required String cartId,
    required String userId,
    required String authToken,
  });

  Future<void> clearCart({
    required String userId,
    required String authToken,
  });

}
