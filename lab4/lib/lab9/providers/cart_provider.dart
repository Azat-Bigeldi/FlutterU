import 'package:flutter/foundation.dart';

import '../models/product.dart';

class CartProvider extends ChangeNotifier {
  final Map<int, Product> _items = {};

  List<Product> get items => List.unmodifiable(_items.values);
  int get count => _items.length;
  bool get isEmpty => _items.isEmpty;

  double get totalPrice => _items.values.fold(0.0, (sum, p) => sum + p.price);

  bool contains(Product p) => _items.containsKey(p.id);

  void add(Product p) {
    _items[p.id] = p;
    notifyListeners();
  }

  void remove(Product p) {
    if (_items.remove(p.id) != null) notifyListeners();
  }

  void toggle(Product p) => contains(p) ? remove(p) : add(p);

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
