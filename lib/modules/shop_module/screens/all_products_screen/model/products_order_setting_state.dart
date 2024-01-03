part of '../vm/products_order_setting_controller.dart';

enum SortType {
  priceLow,
  priceHigh,
  popular,
  newProduct;

  String get name {
    switch (this) {
      case SortType.priceLow:
        return 'Low price';
      case SortType.priceHigh:
        return 'High price';
      case SortType.popular:
        return 'Popular';
      case SortType.newProduct:
        return 'New';
    }
  }

}

class ProductsOrderSettingsState {
  final List<Color> filterColors;
  final SortType sortFilter;

  ProductsOrderSettingsState(
      {this.filterColors = const [], this.sortFilter = SortType.popular});

  ProductsOrderSettingsState copyWith(
      {SortType? sortFilter, List<Color>? filterColors}) {
    return ProductsOrderSettingsState(
      filterColors: filterColors ?? this.filterColors,
      sortFilter: sortFilter ?? this.sortFilter,
    );
  }
}
