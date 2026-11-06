import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../theme.dart';

/// LW9: кнопка-переключатель "В корзину" / "В корзине".
/// Используется в сетке, в списке и на экране товара.
class CartButton extends StatelessWidget {
  final Product product;

  /// compact = только иконка (для строки списка)
  final bool compact;
  final double height;

  const CartButton({
    super.key,
    required this.product,
    this.compact = false,
    this.height = 34,
  });

  @override
  Widget build(BuildContext context) {
    // select: кнопка перерисуется только когда меняется статус ЭТОГО товара
    final inCart =
        context.select<CartProvider, bool>((c) => c.contains(product));
    // read: просто вызываем метод, без подписки
    void onPressed() => context.read<CartProvider>().toggle(product);

    if (compact) {
      return IconButton(
        tooltip: inCart ? 'Убрать из корзины' : 'В корзину',
        onPressed: onPressed,
        icon: Icon(
          inCart ? Icons.shopping_cart : Icons.add_shopping_cart,
          color: inCart ? FlipColors.blue : Colors.black54,
        ),
      );
    }

    final shape =
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(height / 2));

    return SizedBox(
      height: height,
      width: double.infinity,
      child: inCart
          ? OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: FlipColors.blue,
                side: const BorderSide(color: FlipColors.blue),
                padding: EdgeInsets.zero,
                shape: shape,
              ),
              onPressed: onPressed,
              icon: const Icon(Icons.check, size: 18),
              label: const Text('В корзине'),
            )
          : FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: FlipColors.yellow,
                foregroundColor: Colors.black,
                padding: EdgeInsets.zero,
                shape: shape,
              ),
              onPressed: onPressed,
              icon: const Icon(Icons.add_shopping_cart, size: 18),
              label: const Text('В корзину'),
            ),
    );
  }
}
