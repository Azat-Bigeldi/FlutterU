import 'package:flutter/material.dart';

import '../models/product.dart';
import '../theme.dart';
import 'category_tag.dart';
import 'product_image.dart';
import 'rating_stars.dart';

/// Строка ленты (List mode): обложка-аватар, название, тег категории,
/// рейтинг и цена.
class ProductListTile extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const ProductListTile({super.key, required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: FlipColors.card,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              // Аватар — мини-обложка книги
              Hero(
                tag: 'img_${product.id}',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    width: 52,
                    height: 72,
                    child: ProductImage(url: product.imageUrl, fit: BoxFit.cover),
                  ),
                ),
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
                        Flexible(child: CategoryTag(label: product.category)),
                        const SizedBox(width: 8),
                        RatingStars(rating: product.rating),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(formatPrice(product.price),
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w800)),
                  Text(formatPrice(product.oldPrice),
                      style: const TextStyle(
                          fontSize: 12,
                          color: FlipColors.grey,
                          decoration: TextDecoration.lineThrough)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
