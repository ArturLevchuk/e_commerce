import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:dio/dio.dart';
import '../utils/connection_exception.dart';
import '/apis/models/cart_item.dart';

import '/apis/models/order_item.dart';

import '../utils/server_exception.dart';
import 'abstract/orders_api.dart';

class FirebaseOrdersApi implements OrdersApi {
  final String webDatabaseUrl =
      'https://e-commerce-26828-default-rtdb.firebaseio.com';
  final String webKey = 'AIzaSyChOUUVJgZ-OicuvmXr6Q83O9spplyzNSk';
  final Dio dioClient = Dio();

  @override
  Future<String> addOrder({
    required List<CartItem> cartProducts,
    required double totalPrice,
    required String arrivePlace,
    required String payment,
    required DateTime timeCode,
    required String userId,
    required String authToken,
  }) async {
    try {
      final url =
          Uri.parse("$webDatabaseUrl/orders/$userId.json?auth=$authToken");
      final response = await dioClient.postUri(
        url,
        data: json.encode(
          {
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
          },
        ),
      );
      return response.data['name'];
    } on DioError catch (err) {
      if (err.error is SocketException) {
        throw ConnectionException();
      } else if (err.type == DioErrorType.response) {
        throw ServerException();
      } else {
        rethrow;
      }
    } catch (err) {
      rethrow;
    }
  }

  @override
  Future<void> cancelOrder({
    required String orderId,
    required String userId,
    required String authToken,
  }) async {
    try {
      final url = Uri.parse(
          "$webDatabaseUrl/orders/$userId/$orderId.json?auth=$authToken");
      await dioClient.deleteUri(url);
    } on DioError catch (err) {
      if (err.error is SocketException) {
        throw ConnectionException();
      } else if (err.type == DioErrorType.response) {
        throw ServerException();
      } else {
        rethrow;
      }
    } catch (err) {
      rethrow;
    }
  }

  @override
  Future<List<OrderItem>> fetchAndSetOrders({
    required String userId,
    required String authToken,
  }) async {
    try {
      final url =
          Uri.parse("$webDatabaseUrl/orders/$userId.json?auth=$authToken");
      final response = await dioClient.getUri(url);
      final ordersData = response.data as Map<String, dynamic>?;
      if (ordersData == null) {
        return [];
      }
      final List<OrderItem> loadedOrders = [];
      ordersData.forEach((orderId, orderInfo) {
        loadedOrders.add(OrderItem(
          id: orderId,
          arrivePlace: orderInfo['arrivePlace'],
          payment: orderInfo['payment'],
          status: orderInfo['status'],
          totalPrice: orderInfo['totalPrice'],
          dateTime: DateTime.parse(orderInfo['dateTime']),
          products: List<Map>.from(orderInfo['products'])
              .map(
                (cartItem) => CartItem(
                  productId: cartItem['productId'],
                  numOfItem: cartItem['numOfItem'],
                  color: Color(cartItem['color']),
                ),
              )
              .toList(),
        ));
      });
      return loadedOrders;
    } on DioError catch (err) {
      if (err.error is SocketException) {
        throw ConnectionException();
      } else if (err.type == DioErrorType.response) {
        throw ServerException();
      } else {
        rethrow;
      }
    } catch (err) {
      rethrow;
    }
  }
}
