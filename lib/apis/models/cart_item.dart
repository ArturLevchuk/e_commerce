// ignore_for_file: hash_and_equals

import 'dart:ui';

class CartItem {
  final String productId;
  final int numOfItem;
  final Color color;

  const CartItem({
    required this.productId,
    required this.numOfItem,
    required this.color,
  });

  CartItem copyWith({
    String? productId,
    int? numOfItem,
    Color? color,
  }) {
    return CartItem(
      productId: productId ?? this.productId,
      numOfItem: numOfItem ?? this.numOfItem,
      color: color ?? this.color,
    );
  }

  @override
   bool operator == (Object other) {
    return other is CartItem &&
        productId == other.productId &&
        color == other.color;
  }
  
}
