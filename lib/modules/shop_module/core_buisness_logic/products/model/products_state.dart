part of '../vm/products_controller.dart';

enum ProductsLoadStatus { initial, loading, loaded}

@immutable
class ProductsState {
  final List<Product> items;
  final ProductsLoadStatus productsLoadStatus;

  const ProductsState({
    this.items = const [],
    this.productsLoadStatus = ProductsLoadStatus.initial,
  });

  ProductsState copyWith({
    List<Product>? items,
    ProductsLoadStatus? productsLoadStatus,
  }) {
    return ProductsState(
      items: items ?? this.items,
      productsLoadStatus: productsLoadStatus ?? this.productsLoadStatus,
    );
  }

  List<Product> get favItems {
    return items.where((product) => product.isFavorite == true).toList();
  }

  List<Product> get popularItems {
    final popular = items..sort((a, b) => b.rating.compareTo(a.rating));
    return popular.take(4).toList();
  }

  Product prodById(String id) {
    return items.firstWhere((element) => element.id == id);
  }

  bool favById(String id) {
    return items.firstWhere((element) => element.id == id).isFavorite;
  }

  double getPriceOfItem(String id) {
    return items.firstWhere((element) => element.id == id).price;
  }
}
