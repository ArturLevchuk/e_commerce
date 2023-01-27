import 'cart_item.dart';

class OrderItem {
  final String id;
  final List<CartItem> products;
  final double totalPrice;
  final String arrivePlace;
  final String payment;
  final String status;
  final DateTime dateTime;

  OrderItem({
    required this.id,
    required this.products,
    required this.totalPrice,
    required this.payment,
    required this.arrivePlace,
    this.status = "Order in processing...",
    required this.dateTime,
  });
}
