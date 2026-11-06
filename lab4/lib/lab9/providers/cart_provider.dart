import 'package:flutter/foundation.dart';

import '../models/product.dart';

/// LW9: глобальное состояние корзины.
/// Один экземпляр на всё приложение (создаётся в main9.dart),
/// каталог, карточка товара и экран корзины работают с ним через Provider.
class CartProvider extends ChangeNotifier {
  // Map по id: нет дублей, поиск O(1), порядок добавления сохраняется.
  final Map<String, Product> _items = {};

  List<Product> get items => List.unmodifiable(_items.values);
  int get count => _items.length;
  bool get isEmpty => _items.isEmpty;

  int get totalPrice => _items.values.fold(0, (sum, p) => sum + p.price);

  /// Сколько экономит покупатель по сравнению со старыми ценами.
  int get totalSaving =>
      _items.values.fold(0, (sum, p) => sum + (p.oldPrice - p.price));

  bool contains(Product p) => _items.containsKey(p.id);

  void add(Product p) {
    _items[p.id] = p;
    notifyListeners();
  }

  void remove(Product p) {
    if (_items.remove(p.id) != null) notifyListeners();
  }

  /// Переключатель "В корзину / В корзине" на каталоге.
  void toggle(Product p) => contains(p) ? remove(p) : add(p);

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
