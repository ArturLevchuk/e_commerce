import 'dart:ui';
import 'package:equatable/equatable.dart';


class CartItem extends Equatable {
  final String productId;
  final int numOfItem;
  final Color color;

  const CartItem({
    required this.productId,
    required this.numOfItem,
    required this.color,
  });
  
  @override
  List<Object?> get props => [productId, numOfItem, color];
}