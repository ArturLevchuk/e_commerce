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
    final String? status,
    required this.dateTime,
  }) : _payment = payment , status = status ?? "Order in processing...";

  String get payment {
    return _payment.contains("Payment upon receipt")
        ? "Payment upon receipt"
        : "Paid by card";
  }
}
