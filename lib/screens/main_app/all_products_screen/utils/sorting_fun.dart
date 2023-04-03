import 'dart:ui';
import '../../../../repositories/models/product.dart';
import '../products_order_settings_bloc/products_order_settings_bloc.dart';

List<Product> productsBySearch(
    List<Product> allProducts, String searchTag, SortType sortFilter) {
  if (searchTag.length < 2) {
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

List<Product> sortedProducts(List<Product> allProducts, SortType sortFilter) {
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

List<Product> filteredProducts(
    List<Product> allProducts, List<Color> filterColors) {
  return allProducts
      .where((prod) => prod.colors.toSet().containsAll(filterColors))
      .toList();
}
