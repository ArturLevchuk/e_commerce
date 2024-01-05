import 'dart:io';
import 'dart:ui';

import 'package:dio/dio.dart';
import '../utils/connection_exception.dart';
import '../utils/server_exception.dart';
import '/apis/abstract/cart_api.dart';
import 'models/cart_item.dart';

class FirebaseCartApi implements CartApi {
  final String webDatabaseUrl =
      'https://e-commerce-26828-default-rtdb.firebaseio.com';
  final String webKey = 'AIzaSyChOUUVJgZ-OicuvmXr6Q83O9spplyzNSk';

  final Dio dioClient = Dio();

  @override
  Future<Map<String, CartItem>> fetchAndSetCart(
      {required String userId, required String authToken}) async {
    try {
      final url =
          Uri.parse("$webDatabaseUrl/cart/$userId.json?auth=$authToken");
      final response = await dioClient.getUri(url);
      final cartData = response.data as Map<String, dynamic>?;
      if (cartData == null) {
        return {};
      }
      final Map<String, CartItem> loadedCartItems = {};
      cartData.forEach((cartId, cartData) {
        loadedCartItems[cartId] = CartItem(
          productId: cartData['productId'],
          numOfItem: cartData['numOfItem'],
          color: Color(cartData['color']),
        );
      });
      return loadedCartItems;
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
  Future<String> addToCart({
    required String productId,
    required int numOfItem,
    required Color color,
    required String userId,
    required String authToken,
  }) async {
    try {
      final url =
          Uri.parse("$webDatabaseUrl/cart/$userId.json?auth=$authToken");
      final response = await dioClient.postUri(url, data: {
        'productId': productId,
        'numOfItem': numOfItem,
        'color': color.value,
      });
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
  Future<void> updateCart({
    required String cartId,
    required int numOfItem,
    required String userId,
    required String authToken,
  }) async {
    try {
      final url = Uri.parse(
          "$webDatabaseUrl/cart/$userId/$cartId.json?auth=$authToken");
      await dioClient.patchUri(url, data: {
        'numOfItem': numOfItem,
      });
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
  Future<void> removeFromCart({
    required String cartId,
    required String userId,
    required String authToken,
  }) async {
    try {
      final url = Uri.parse(
          "$webDatabaseUrl/cart/$userId/$cartId.json?auth=$authToken");
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
  Future<void> clearCart(
      {required String userId, required String authToken}) async {
    try {
      final url =
          Uri.parse("$webDatabaseUrl/cart/$userId.json?auth=$authToken");
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
}
