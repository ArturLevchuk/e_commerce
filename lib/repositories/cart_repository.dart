import 'dart:convert';
import 'dart:ui';
import 'package:e_commerce/utils/HttpException.dart';
import 'package:http/http.dart' as http;

import 'models/cart_item.dart';

class CartRepository {
  final String userId;
  final String authToken;
  CartRepository({required this.userId, required this.authToken});

  Future<Map<String, CartItem>> fetchAndSetCart() async {
    try {
      final url = Uri.parse(
          'https://e-commerce-26828-default-rtdb.firebaseio.com/cart/$userId.json?auth=$authToken');
      final http.Response response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>?;
      if (extractedData == null) {
        return {};
      }
      final Map<String, CartItem> loadedProducts = {};
      extractedData.forEach((cartId, cartData) {
        loadedProducts.putIfAbsent(
          cartId,
          () => CartItem(
            productId: cartData['productId'],
            numOfItem: cartData['numOfItem'],
            color: Color(
              cartData['color'],
            ),
          ),
        );
      });
      return loadedProducts;
    } catch (err) {
      throw HttpException(err.toString());
    }
  }

  Future<Map<String, CartItem>> addToCart({
    required String productId,
    required int numOfItem,
    required Color color,
    required Map<String, CartItem> items,
  }) async {
    try {
      for (var i = 0; i < items.length; i++) {
        if (items.values.elementAt(i).productId == productId &&
            items.values.elementAt(i).color == color) {
          final key = items.keys.elementAt(i);
          final url = Uri.parse(
              'https://e-commerce-26828-default-rtdb.firebaseio.com/cart/$userId/$key.json?auth=$authToken');
          final response = await http.patch(url,
              body: json.encode({
                "numOfItem": items.values.elementAt(i).numOfItem + numOfItem,
              }));
          if (response.statusCode >= 400) {
            throw HttpException("${response.statusCode}");
          }
          items.update(
            key,
            (oldCartItem) => CartItem(
                productId: productId,
                numOfItem: oldCartItem.numOfItem + numOfItem,
                color: color),
          );
          return items;
        }
      }
      final url = Uri.parse(
          'https://e-commerce-26828-default-rtdb.firebaseio.com/cart/$userId.json?auth=$authToken');
      final response = await http.post(url,
          body: json.encode({
            "productId": productId,
            "numOfItem": numOfItem,
            "color": color.value,
          }));
      if (response.statusCode >= 400) {
        throw "${response.statusCode}";
      }
      items.putIfAbsent(
        json.decode(response.body)['name'],
        () => CartItem(
          productId: productId,
          numOfItem: numOfItem,
          color: color,
        ),
      );
      return items;
    } catch (err) {
      rethrow;
    }
  }

  Future<Map<String, CartItem>> removeCartItem({
    required int index,
    required Map<String, CartItem> items,
  }) async {
    final key = items.keys.elementAt(index);
    try {
      final url = Uri.parse(
          'https://e-commerce-26828-default-rtdb.firebaseio.com/cart/$userId/$key.json?auth=$authToken');
      final response = await http.delete(url);
      if (response.statusCode >= 400) {
        throw HttpException("${response.statusCode}");
      }
    } catch (err) {
      rethrow;
    } finally {
      items.remove(key);
      // ignore: control_flow_in_finally
      return items;
    }
  }

  Future<void> clearCart() async {
    try {
      final url = Uri.parse(
          'https://e-commerce-26828-default-rtdb.firebaseio.com/cart/$userId.json?auth=$authToken');
      final response = await http.delete(url);
      if (response.statusCode >= 400) {
        throw HttpException("${response.statusCode}");
      }
    } catch (err) {
      rethrow;
    }
  }

}
