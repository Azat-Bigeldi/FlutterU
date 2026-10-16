import 'package:flutter/material.dart';

import '../data/favorites_store.dart';
import '../models/product.dart';
import '../theme.dart';
import '../widgets/product_image.dart';

/// Экран товара. Получает весь объект Product через конструктор.
class DetailScreen extends StatelessWidget {
  final Product product;
  final FavoritesStore favorites;

  const DetailScreen({
    super.key,
    required this.product,
    required this.favorites,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Кнопка назад в AppBar -> Navigator.pop
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(product.category, style: const TextStyle(fontSize: 16)),
        actions: [
          ListenableBuilder(
            listenable: favorites,
            builder: (context, _) {
              final fav = favorites.contains(product);
              return IconButton(
                icon: Icon(fav ? Icons.favorite : Icons.favorite_border,
                    color: fav ? FlipColors.red : Colors.black87),
                onPressed: () => favorites.toggle(product),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            height: 320,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Hero(
              tag: 'img_${product.id}',
              child: ProductImage(url: product.imageUrl),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(formatPrice(product.price),
                        style: const TextStyle(
                            fontSize: 26, fontWeight: FontWeight.w800)),
                    const SizedBox(width: 8),
                    Text(formatPrice(product.oldPrice),
                        style: const TextStyle(
                            color: FlipColors.grey,
                            decoration: TextDecoration.lineThrough)),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: FlipColors.red,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text('−${product.discountPercent}%',
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(product.title,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(product.author,
                    style:
                        const TextStyle(fontSize: 15, color: FlipColors.grey)),
                const SizedBox(height: 12),
                _InfoRow(label: 'Категория', value: product.category),
                _InfoRow(label: 'Издание', value: product.details),
                const _InfoRow(label: 'Продавец', value: 'Flip'),
                const SizedBox(height: 12),
                const Text('Описание',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                Text(product.description,
                    style: const TextStyle(fontSize: 15, height: 1.4)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Кнопка назад в теле экрана -> Navigator.pop
          SizedBox(
            height: 54,
            child: FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: FlipColors.yellow,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28)),
              ),
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Вернуться назад',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(label, style: const TextStyle(color: FlipColors.grey)),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
