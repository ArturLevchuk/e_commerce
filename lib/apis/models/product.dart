// ignore_for_file: hash_and_equals

import 'package:flutter/material.dart';

class Product {
  final String id;
  final String title, description;
  final List<String> images;
  final List<Color> colors;
  final double rating, price, prevPrice;
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
    this.prevPrice = 0,
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
      prevPrice: prevPrice,
      isFavorite: newFavorite,
    );
  }

  factory Product.fromData({
    required String id,
    required Map<String, dynamic> data,
    required bool isFavorite,
  }) {
    return Product(
      id: id,
      images: List<String>.from(data['images']),
      colors: (data['colors'] as List<dynamic>)
          .map((color) => Color(int.parse(color)))
          .toList(),
      title: data['title'],
      price: data['price'].toDouble(),
      prevPrice: data['prev_pice'] ?? 0,
      rating: data['rating'].toDouble(),
      inStockCount: data['inStockCount'],
      description: data['description'],
      isFavorite: isFavorite,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is Product && id == other.id && isFavorite == other.isFavorite;
  }
}
