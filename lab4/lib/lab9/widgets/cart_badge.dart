import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import '../screens/cart_screen.dart';
import '../theme.dart';

/// LW9: иконка корзины в AppBar с живым счётчиком.
/// select -> перерисовывается только когда меняется количество.
class CartBadge extends StatelessWidget {
  const CartBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final count = context.select<CartProvider, int>((c) => c.count);

    return IconButton(
      tooltip: 'Корзина',
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const CartScreen()),
      ),
      icon: Badge(
        isLabelVisible: count > 0,
        label: Text('$count'),
        backgroundColor: FlipColors.red,
        child: const Icon(Icons.shopping_cart_outlined),
      ),
    );
  }
}
