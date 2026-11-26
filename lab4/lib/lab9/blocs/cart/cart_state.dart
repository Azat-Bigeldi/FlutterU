import 'package:equatable/equatable.dart';

import '../../models/product.dart';

class CartState extends Equatable {
  final List<Product> items;
  final double totalPrice;
  final int count;

  /// totalPrice и count всегда вычисляются из items и не расходятся с ним.
  CartState({List<Product> items = const []})
    : items = List.unmodifiable(items),
      totalPrice = items.fold(0.0, (sum, p) => sum + p.price),
      count = items.length;

  bool get isEmpty => items.isEmpty;

  bool contains(int productId) => items.any((p) => p.id == productId);

  @override
  List<Object?> get props => [items, totalPrice, count];
}
