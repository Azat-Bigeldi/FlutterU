import 'package:flutter/material.dart';

import '../data/favorites_store.dart';
import '../models/product.dart';
import '../theme.dart';
import 'product_image.dart';
import 'rating_stars.dart';

/// Карточка товара для Grid mode (2 колонки, childAspectRatio 0.72).
/// Без overflow, потому что:
///  - обложка в Expanded — забирает оставшуюся высоту;
///  - у всех текстов maxLines: 1 + ellipsis;
///  - старая цена в Flexible — не вылезает по ширине.
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
                    top: 0,
                    right: 0,
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
              padding: const EdgeInsets.fromLTRB(10, 2, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        formatPrice(product.price),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          formatPrice(product.oldPrice),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 11,
                            color: FlipColors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    product.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      RatingStars(rating: product.rating, size: 13),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          product.author,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 11,
                            color: FlipColors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
