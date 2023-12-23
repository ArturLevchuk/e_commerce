import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:e_commerce/utils/HttpException.dart';
import 'models/product.dart';

const String webPlatform = "https://e-commerce-26828-default-rtdb.firebaseio.com";

class ProductsRepository {
  final String userId;
  final String authToken;

  ProductsRepository({required this.userId, required this.authToken});

  Future<List<Product>> fetchAndSetProducts() async {
    try {
      final url = Uri.parse(
          '$webPlatform/products.json?auth=$authToken');
      final response = await Dio().getUri(url);
      final extractedData = response.data as Map<String, dynamic>?;
      if (extractedData == null) {
        throw HttpException(
            "Looks like something happend on server. Please try later.");
      }
      final favUrl = Uri.parse(
          '$webPlatform/userFavorites/$userId.json?auth=$authToken');
      final favResponse = await Dio().getUri(favUrl);
      final favData = favResponse.data;

      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product.fromJson(prodId, prodData, favData));
      });
      return loadedProducts;
    } on HttpException {
      rethrow;
    } catch (err) {
      throw HttpException((err as DioError).error.toString());
    }
  }

  Future<bool> toggleFavoriteStatus(
      {required bool isFavorite, required String id}) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    final url = Uri.parse(
        '$webPlatform/userFavorites/$userId/$id.json?auth=$authToken');

    try {
      if (!oldStatus) {
        await Dio().putUri(url,
            data: json.encode(
              isFavorite,
            ));
      } else {
        await Dio().deleteUri(url);
      }
    } catch (err) {
      isFavorite = oldStatus;
      return isFavorite;
    }
    return isFavorite;
  }
}
