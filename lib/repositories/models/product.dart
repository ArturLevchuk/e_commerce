import 'dart:ui';
import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String id;
  final String title, description;
  final List<String> images;
  final List<Color> colors;
  // ignore: non_constant_identifier_names
  final double rating, price, prev_price;
  final int inStockCount;
  final bool isFavorite;

  const Product({
    required this.id,
    required this.images,
    required this.colors,
    required this.rating,
    this.isFavorite = false,
    required this.title,
    required this.price,
    // ignore: non_constant_identifier_names
    this.prev_price = 0,
    required this.inStockCount,
    required this.description,
  });

  Product copyWithNewFav(bool newFavorite) {
    return Product(
      id: id,
      images: images,
      colors: colors,
      rating: rating,
      title: title,
      price: price,
      inStockCount: inStockCount,
      description: description,
      prev_price: prev_price,
      isFavorite: newFavorite,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        images,
        colors,
        rating,
        price,
        prev_price,
        inStockCount,
        isFavorite,
      ];
}
