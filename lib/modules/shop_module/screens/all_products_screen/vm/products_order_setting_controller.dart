import 'dart:ui';

import 'package:flutter_modular/flutter_modular.dart';
import 'package:rxdart/rxdart.dart';

part '../model/products_order_setting_state.dart';

class ProductsOrderSettingController extends Disposable {
  final BehaviorSubject<ProductsOrderSettingsState> _streamController =
      BehaviorSubject.seeded(
    ProductsOrderSettingsState(),
  );

  Stream<ProductsOrderSettingsState> get stream => _streamController.stream;
  ProductsOrderSettingsState get state => _streamController.value;

  void changeSorting(SortType sortType) {
    _streamController.add(state.copyWith(sortFilter: sortType));
  }

  void changeFiltering(List<Color> filterColors) {
    _streamController.add(state.copyWith(filterColors: filterColors));
  }

  @override
  void dispose() {
    _streamController.close();
  }
}
