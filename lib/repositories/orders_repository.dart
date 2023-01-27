import 'dart:convert';
import 'dart:ui';
import 'package:http/http.dart' as http;
import '../utils/HttpException.dart';
import 'models/cart_item.dart';
import 'models/order_item.dart';

class OrdersRepository {
  final String userId;
  final String authToken;

  OrdersRepository({
    required this.userId,
    required this.authToken,
  });

  Future<List<OrderItem>> fetchAndSetOrders() async {
    try {
      final url = Uri.parse(
          'https://e-commerce-26828-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken');
      final response = await http.get(url);
      final List<OrderItem> loadedOrders = [];
      final extractedData = json.decode(response.body) as Map<String, dynamic>?;
      if (extractedData == null) {
        return [];
      }
      extractedData.forEach((key, data) {
        loadedOrders.add(OrderItem(
          id: key,
          products: (data['products'] as List<dynamic>)
              .map((cartItem) => CartItem(
                  productId: cartItem['productId'],
                  numOfItem: cartItem['numOfItem'],
                  color: Color(cartItem['color'])))
              .toList(),
          totalPrice: data['totalPrice'],
          payment: data['payment'],
          arrivePlace: data['arrivePlace'],
          dateTime: DateTime.parse(data['dateTime']),
        ));
      });
      return loadedOrders;
    } catch (err) {
      throw HttpException(err.toString());
    }
  }

  Future<void> addOrder({
    required List<CartItem> cartProducts,
    required double totalPrice,
    required String arrivePlace,
    required String payment,
  }) async {
    final DateTime timeCode = DateTime.now();
    try {
      final url = Uri.parse(
          'https://e-commerce-26828-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken');
      final response = await http.post(url,
          body: json.encode({
            "totalPrice": totalPrice,
            "arrivePlace": arrivePlace,
            "payment": payment,
            "products": cartProducts
                .map((cartItem) => {
                      "productId": cartItem.productId,
                      "numOfItem": cartItem.numOfItem,
                      "color": cartItem.color.value,
                    })
                .toList(),
            "dateTime": timeCode.toIso8601String(),
          }));
      if (response.statusCode >= 400) {
        throw HttpException("${response.statusCode}");
      }
    } catch (err) {
      rethrow;
    }
  }

  Future<List<OrderItem>> deleteOrder(
      {required String orderId, required List<OrderItem> orders}) async {
    try {
      final url = Uri.parse(
          'https://e-commerce-26828-default-rtdb.firebaseio.com/orders/$userId/$orderId.json?auth=$authToken');
      final response = await http.delete(url);
      if (response.statusCode >= 400) {
        throw HttpException("${response.statusCode}");
      }
    } catch (err) {
      rethrow;
    } finally {
      orders.removeWhere((orderItem) => orderItem.id == orderId);
      // ignore: control_flow_in_finally
      return orders;
    }
  }
}
