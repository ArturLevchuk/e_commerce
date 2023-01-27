part of 'products_bloc.dart';

@immutable
abstract class ProductsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class RequestProducts extends ProductsEvent {}

class ToggleFav extends ProductsEvent {
  final String id;
  ToggleFav(this.id);
}
