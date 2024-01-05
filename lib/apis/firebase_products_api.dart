import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

import '../utils/connection_exception.dart';
import '../utils/server_exception.dart';
import 'models/product.dart';

import 'abstract/products_api.dart';

class FirebaseProductsApi implements ProductsApi {
  final String webDatabaseUrl =
      'https://e-commerce-26828-default-rtdb.firebaseio.com';
  final String webKey = 'AIzaSyChOUUVJgZ-OicuvmXr6Q83O9spplyzNSk';

  final Dio dioClient = Dio();

  @override
  Future<List<Product>> fetchAndSetProducts(
      {required String userId, required String authToken}) async {
    try {
      final url = Uri.parse('$webDatabaseUrl/products.json?auth=$authToken');
      final response = await dioClient.getUri(url);
      final productsData = response.data as Map<String, dynamic>?;
      if (productsData == null) {
        throw ServerException();
      }
      final userFavProductsUrl = Uri.parse(
          '$webDatabaseUrl/userFavorites/$userId.json?auth=$authToken');
      final response2 = await dioClient.getUri(userFavProductsUrl);
      final userFavProductsList = response2.data as Map<String, dynamic>?;
      final List<Product> loadedProducts = [];
      productsData.forEach((prodId, prodData) {
        loadedProducts.add(
          Product.fromData(
            id: prodId,
            data: productsData[prodId],
            isFavorite: userFavProductsList != null
                ? userFavProductsList[prodId] ?? false
                : false,
          ),
        );
      });
      return loadedProducts;
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
  Future<void> changeFavoriteStatus({
    required bool isFavorite,
    required String productid,
    required String userId,
    required String authToken,
  }) async {
    try {
      final url = Uri.parse(
          '$webDatabaseUrl/userFavorites/$userId/$productid.json?auth=$authToken');
      await dioClient.putUri(url, data: json.encode(isFavorite));
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
