import 'package:flutter/material.dart';

import '../data/favorites_store.dart';
import '../models/product.dart';
import '../theme.dart';
import 'product_image.dart';

/// Карточка товара как в ленте Flip: обложка, сердечко, цена, название.
class ProductCard extends StatelessWidget {
  final Product product;
  final FavoritesStore favorites;
  final VoidCallback onTap;

  const ProductCard({
    super.key,
    required this.product,
    required this.favorites,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: FlipColors.card,
          borderRadius: BorderRadius.circular(14),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Hero(
                        tag: 'img_${product.id}',
                        child: ProductImage(url: product.imageUrl),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: ListenableBuilder(
                      listenable: favorites,
                      builder: (context, _) {
                        final fav = favorites.contains(product);
                        return IconButton(
                          icon: Icon(
                            fav ? Icons.favorite : Icons.favorite_border,
                            color: fav ? FlipColors.red : Colors.black87,
                          ),
                          onPressed: () => favorites.toggle(product),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 4, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        formatPrice(product.price),
                        style: const TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        formatPrice(product.oldPrice),
                        style: const TextStyle(
                          fontSize: 12,
                          color: FlipColors.grey,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(product.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 15)),
                  Text(product.details,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style:
                          const TextStyle(fontSize: 12, color: FlipColors.grey)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
