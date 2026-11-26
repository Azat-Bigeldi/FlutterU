import 'package:flutter/foundation.dart';

import '../models/product.dart';

/// Хранилище избранного. Живёт в RootScreen, поэтому состояние
/// не теряется при переходах между вкладками и экранами.
class FavoritesStore extends ChangeNotifier {
  final List<Product> _items = [];

  List<Product> get items => List.unmodifiable(_items);

  bool contains(Product p) => _items.any((e) => e.id == p.id);

  void toggle(Product p) {
    if (contains(p)) {
      _items.removeWhere((e) => e.id == p.id);
    } else {
      _items.add(p);
    }
    notifyListeners();
  }
}
