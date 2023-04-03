import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'products_order_settings_event.dart';
part 'products_order_settings_state.dart';

class ProductsOrderSettingsBloc
    extends Bloc<ProductsOrderSettingsEvent, ProductsOrderSettingsState> {
  ProductsOrderSettingsBloc() : super(ProductsOrderSettingsState()) {
    on<UpdateSorting>(_onUpdateSorting);
    on<UpdateFiltering>(_onUpdateFiltering);
  }

  void _onUpdateSorting(
    UpdateSorting event,
    Emitter<ProductsOrderSettingsState> emit,
  ) async {
    emit(state.copyWith(sortFilter: event.sortType));
  }

  void _onUpdateFiltering(
    UpdateFiltering event,
    Emitter<ProductsOrderSettingsState> emit,
  ) async {
    emit(state.copyWith(filterColors: event.filterColors));
  }
}
