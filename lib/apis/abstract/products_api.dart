import '../models/product.dart';

abstract interface class ProductsApi {
  Future<List<Product>> fetchAndSetProducts({
    required String userId,
    required String authToken,
  });

  Future<void> changeFavoriteStatus({
    required bool isFavorite,
    required String productid,
    required String userId,
    required String authToken,
  });
}
