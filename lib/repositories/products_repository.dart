import 'dart:convert';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:e_commerce/utils/HttpException.dart';
import 'models/product.dart';

class ProductsRepository {
  final String userId;
  final String authToken;

  ProductsRepository({required this.userId, required this.authToken});

  Future<List<Product>> fetchAndSetProducts() async {
    try {
      final url = Uri.parse(
          'https://e-commerce-26828-default-rtdb.firebaseio.com/products.json?auth=$authToken');
      final response = await Dio().getUri(url);
      final extractedData = response.data as Map<String, dynamic>?;
      if (extractedData == null) {
        throw HttpException(
            "Looks like something happend on server. Please try later.");
      }
      final favUrl = Uri.parse(
          'https://e-commerce-26828-default-rtdb.firebaseio.com/userFavorites/$userId.json?auth=$authToken');
      final favResponse = await Dio().getUri(favUrl);
      final favData = favResponse.data;

      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
          id: prodId,
          images: (prodData['images'] as List<dynamic>)
              .map((str) => str.toString())
              .toList(),
          colors: (prodData['colors'] as List<dynamic>)
              .map((color) => Color(int.parse(color)))
              .toList(),
          title: prodData['title'],
          price: prodData['price'],
          prev_price: prodData['prev_price'] ?? 0,
          rating: prodData['rating'],
          inStockCount: prodData['inStockCount'],
          description: prodData['description'],
          isFavorite: favData == null ? false : favData[prodId] ?? false,
        ));
      });
      return loadedProducts;
    } catch (err) {
      throw HttpException((err as DioError).error.toString());
    }
  }

  Future<bool> toggleFavoriteStatus(
      {required bool isFavorite, required String id}) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    final url = Uri.parse(
        'https://e-commerce-26828-default-rtdb.firebaseio.com/userFavorites/$userId/$id.json?auth=$authToken');

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
