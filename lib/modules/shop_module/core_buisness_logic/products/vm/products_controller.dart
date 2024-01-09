import 'dart:developer';

import 'package:flutter/foundation.dart';

import '/apis/abstract/products_api.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../../apis/models/product.dart';

part '../model/products_state.dart';

class ProductsController extends Disposable {
  final ProductsApi _productsApi;
  ProductsController(this._productsApi);

  final BehaviorSubject<ProductsState> _streamController =
      BehaviorSubject.seeded(const ProductsState());

  Stream<ProductsState> get stream => _streamController.stream.distinct(
    (previous, next) => previous == next,
  );
  ProductsState get state => _streamController.value;

  Future<void> fetchAndSetProducts({
    required String userId,
    required String authToken,
    bool silentUpdate = false,
  }) async {
    try {
      if (!silentUpdate) {
        _streamController.add(
          state.copyWith(
            productsLoadStatus: ProductsLoadStatus.loading,
          ),
        );
      }

      final products = await _productsApi.fetchAndSetProducts(
        userId: userId,
        authToken: authToken,
      );
      _streamController.add(
        state.copyWith(
          items: products,
          productsLoadStatus: ProductsLoadStatus.loaded,
        ),
      );
    } catch (err) {
      _streamController.add(state.copyWith(
        productsLoadStatus: ProductsLoadStatus.initial,
      ));
      log(err.toString());
      rethrow;
    }
  }

  Future<void> changeFavoriteStatus({
    required String productid,
    required String userId,
    required String authToken,
  }) async {
    try {
      final bool favoriteStatus = state.prodById(productid).isFavorite;
      _productsApi.changeFavoriteStatus(
        isFavorite: !favoriteStatus,
        productid: productid,
        userId: userId,
        authToken: authToken,
      );
      final newProductList = List.of(state.items);
      final index =
          newProductList.indexWhere((element) => element.id == productid);
      newProductList[index] =
          state.prodById(productid).copyWithNewFav(!favoriteStatus);
      _streamController.add(state.copyWith(items: newProductList));
    } catch (err) {
      log(err.toString());
      rethrow;
    }
  }

  @override
  void dispose() {
    _streamController.close();
  }
}
