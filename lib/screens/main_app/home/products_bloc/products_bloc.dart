import 'package:bloc/bloc.dart';
import 'package:e_commerce/repositories/models/product.dart';
import 'package:e_commerce/repositories/products_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'products_event.dart';
part 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  ProductsBloc(this._productsRepository)
      : super(const ProductsState(
            productsLoadStatus: ProductsLoadStatus.initial)) {
    on<RequestProducts>(_onRequestProducts);
    on<ToggleFav>(_onToggleFav);
  }

  final ProductsRepository _productsRepository;

  void _onRequestProducts(
    RequestProducts event,
    Emitter<ProductsState> emit,
  ) async {
    try {
      emit(state.copyWith(productsLoadStatus: ProductsLoadStatus.loading));
      final products = await _productsRepository.fetchAndSetProducts();
      emit(state.copyWith(
          items: products, productsLoadStatus: ProductsLoadStatus.loaded));
    } catch (err) {
      emit(state.copyWith(
          productsLoadStatus: ProductsLoadStatus.error, error: err.toString()));
    }
  }

  void _onToggleFav(
    ToggleFav event,
    Emitter<ProductsState> emit,
  ) async {
    List<Product> products = state.items;
    final index = products.indexWhere((element) => element.id == event.id);
    final finalBool = await _productsRepository.toggleFavoriteStatus(
        isFavorite: products[index].isFavorite, id: event.id);
    products[index] = products[index].copyWithNewFav(finalBool);
    emit(state.copyWith(items: products, error: null));
    
  }
}
