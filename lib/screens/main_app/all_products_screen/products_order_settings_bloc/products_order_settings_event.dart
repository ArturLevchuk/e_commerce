part of 'products_order_settings_bloc.dart';

abstract class ProductsOrderSettingsEvent extends Equatable {
  const ProductsOrderSettingsEvent();

  @override
  List<Object> get props => [];
}

class UpdateSorting extends ProductsOrderSettingsEvent {
  final SortType sortType;
  const UpdateSorting({required this.sortType});
  @override
  List<Object> get props => [sortType];
}

class UpdateFiltering extends ProductsOrderSettingsEvent {
  final List<Color> filterColors;
  const UpdateFiltering({required this.filterColors});
  @override
  List<Object> get props => [...filterColors];
}
