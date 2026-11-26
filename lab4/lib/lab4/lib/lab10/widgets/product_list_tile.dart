import 'package:flutter/material.dart';

import '../models/product.dart';
import '../theme.dart';
import 'category_tag.dart';
import 'product_image.dart';
import 'rating_stars.dart';

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
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Row(
            children: [
              SizedBox(
                width: 64,
                height: 64,
                child: Hero(
                  tag: 'product_image_${product.id}',
                  child: ProductImage(url: product.imageUrl),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Flexible(child: CategoryTag(label: product.category)),
                        const SizedBox(width: 8),
                        RatingStars(rating: product.rating),
                        const SizedBox(width: 4),
                        Text('(${product.reviewCount})',
                            style: const TextStyle(
                                fontSize: 12, color: FlipColors.grey)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text(formatPrice(product.price),
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w800)),
            ],
          ),
        ),
      ),
    );
  }
}
