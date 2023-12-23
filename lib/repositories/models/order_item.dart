import 'cart_item.dart';

class OrderItem {
  final String id;
  final List<CartItem> products;
  final double totalPrice;
  final String arrivePlace;
  final String _payment;
  final String status;
  final DateTime dateTime;

  OrderItem({
    required this.id,
    required this.products,
    required this.totalPrice,
    required String payment,
    required this.arrivePlace,
    this.status = "Order in processing...",
    required this.dateTime,
  }) : _payment = payment;

  String get payment {
    return _payment.contains("Payment upon receipt")
        ? "Payment upon receipt"
        : "Paid by card";
  }
}
