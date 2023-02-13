part of 'products_bloc.dart';

enum ProductsLoadStatus { initial, loading, loaded, error }

@immutable
class ProductsState {
  final List<Product> items;
  final ProductsLoadStatus productsLoadStatus;
  final String? error;

  const ProductsState(
      {this.items = const [], required this.productsLoadStatus, this.error});

  ProductsState copyWith(
      {List<Product>? items,
      ProductsLoadStatus? productsLoadStatus,
      String? error}) {
    return ProductsState(
      items: items ?? this.items,
      productsLoadStatus: productsLoadStatus ?? this.productsLoadStatus,
      error: error,
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
