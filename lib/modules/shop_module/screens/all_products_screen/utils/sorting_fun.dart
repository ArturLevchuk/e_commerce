import 'dart:ui';

import '../../../../../apis/models/product.dart';
import '../vm/products_order_setting_controller.dart';

class ProductsShowOrder {
  static List<Product> productsBySearch(
    List<Product> allProducts,
    String searchTag,
    SortType sortFilter,
  ) {
    if (searchTag.isEmpty) {
      return sortedProducts(allProducts, sortFilter);
    }
    return sortedProducts(allProducts, sortFilter)
        .where(
          (product) => product.title.contains(
            RegExp(searchTag, caseSensitive: false),
          ),
        )
        .toList();
  }

  static List<Product> sortedProducts(List<Product> allProducts, SortType sortFilter) {
    switch (sortFilter) {
      case SortType.popular:
        return allProducts..sort((a, b) => b.rating.compareTo(a.rating));
      case SortType.newProduct:
        return allProducts.reversed.toList();
      case SortType.priceHigh:
        return allProducts..sort((a, b) => b.price.compareTo(a.price));
      case SortType.priceLow:
        return allProducts..sort((a, b) => a.price.compareTo(b.price));
      default:
        return allProducts;
    }
  }

  static List<Product> filteredProducts(
      List<Product> allProducts, List<Color> filterColors) {
    return allProducts
        .where((prod) => prod.colors.toSet().containsAll(filterColors))
        .toList();
  }
}
