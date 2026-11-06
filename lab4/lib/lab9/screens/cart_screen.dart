import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../theme.dart';
import '../widgets/product_image.dart';

/// LW9 — Screen 2 (Cart View):
/// список выбранных товаров, удаление по одному, итог, "Очистить всё".
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // watch: экран перестраивается при любом изменении корзины
    final cart = context.watch<CartProvider>();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          children: [
            const Text('Корзина',
                style: TextStyle(fontWeight: FontWeight.w700)),
            Text('${cart.count} товаров',
                style: const TextStyle(fontSize: 12, color: FlipColors.grey)),
          ],
        ),
        actions: [
          if (!cart.isEmpty)
            IconButton(
              tooltip: 'Очистить всё',
              icon: const Icon(Icons.delete_sweep_outlined,
                  color: FlipColors.red),
              onPressed: () => _confirmClear(context),
            ),
        ],
      ),
      body: cart.isEmpty
          ? const _EmptyCart()
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: cart.items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, i) => _CartItem(product: cart.items[i]),
            ),
      bottomNavigationBar: cart.isEmpty ? null : _Summary(cart: cart),
    );
  }

  Future<void> _confirmClear(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Очистить корзину?'),
        content: const Text('Все товары будут удалены из корзины.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Отмена'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: FlipColors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Очистить'),
          ),
        ],
      ),
    );
    // После await контекст мог исчезнуть
    if (ok == true && context.mounted) {
      context.read<CartProvider>().clear();
    }
  }
}

class _CartItem extends StatelessWidget {
  final Product product;
  const _CartItem({required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: FlipColors.card,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          // Без Hero: тот же tag уже есть на экране каталога под нами
          SizedBox(
            width: 60,
            height: 86,
            child: ProductImage(url: product.imageUrl),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600)),
                Text(product.author,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: FlipColors.grey)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(formatPrice(product.price),
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w800)),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(formatPrice(product.oldPrice),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 12,
                              color: FlipColors.grey,
                              decoration: TextDecoration.lineThrough)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Удалить',
            icon: const Icon(Icons.close, color: FlipColors.grey),
            onPressed: () => context.read<CartProvider>().remove(product),
          ),
        ],
      ),
    );
  }
}

class _Summary extends StatelessWidget {
  final CartProvider cart;
  const _Summary({required this.cart});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Text('Экономия', style: TextStyle(color: FlipColors.grey)),
                const Spacer(),
                Text('−${formatPrice(cart.totalSaving)}',
                    style: const TextStyle(
                        color: FlipColors.red, fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Text('Итого',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                const Spacer(),
                Text(formatPrice(cart.totalPrice),
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.w800)),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 52,
              width: double.infinity,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: FlipColors.yellow,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26)),
                ),
                onPressed: () => ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(const SnackBar(
                    behavior: SnackBarBehavior.floating,
                    content: Text('Оформление заказа — в следующей лабе 🙂'),
                  )),
                child: const Text('Оформить заказ',
                    style:
                        TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyCart extends StatelessWidget {
  const _EmptyCart();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.shopping_cart_outlined,
                size: 96, color: FlipColors.grey),
            const SizedBox(height: 16),
            const Text('Корзина пуста',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            const Text('Добавьте книги из каталога',
                style: TextStyle(color: FlipColors.grey, fontSize: 15)),
            const SizedBox(height: 24),
            SizedBox(
              height: 50,
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: FlipColors.yellow,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                ),
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
                label: const Text('В каталог',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
