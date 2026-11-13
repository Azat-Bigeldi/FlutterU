import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../theme.dart';
import '../widgets/cart_badge.dart';
import '../widgets/category_tag.dart';
import '../widgets/photo_carousel.dart';
import '../widgets/rating_stars.dart';
import '../widgets/share_sheet.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            tooltip: 'Поделиться',
            icon: const Icon(Icons.ios_share),
            onPressed: () => showShareSheet(context, product),
          ),
          const CartBadge(),
          const SizedBox(width: 4),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          PhotoCarousel(
            images: product.gallery,
            heroTag: 'product_image_${product.id}',
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
                    Flexible(child: CategoryTag(label: product.category)),
                    const Spacer(),
                    RatingStars(rating: product.rating, size: 18),
                    const SizedBox(width: 6),
                    Text('${product.reviewCount} отзывов',
                        style: const TextStyle(
                            fontSize: 13, color: FlipColors.grey)),
                  ],
                ),
                const SizedBox(height: 12),
                Text(product.title,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w600)),
                const SizedBox(height: 16),
                const Text('Описание',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                Text(product.description,
                    style: const TextStyle(fontSize: 15, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _BottomBar(product: product),
    );
  }
}

class _BottomBar extends StatelessWidget {
  final Product product;

  const _BottomBar({required this.product});

  @override
  Widget build(BuildContext context) {
    final inCart =
        context.select<CartProvider, bool>((c) => c.contains(product));
    final shape =
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(26));
    const labelStyle = TextStyle(fontSize: 17, fontWeight: FontWeight.w600);

    void onPressed() => context.read<CartProvider>().toggle(product);

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Цена',
                    style: TextStyle(fontSize: 12, color: FlipColors.grey)),
                Text(formatPrice(product.price),
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.w800)),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: SizedBox(
                height: 52,
                child: inCart
                    ? OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: FlipColors.blue,
                          side: const BorderSide(color: FlipColors.blue),
                          shape: shape,
                        ),
                        onPressed: onPressed,
                        icon: const Icon(Icons.check),
                        label: const Text('In Cart', style: labelStyle),
                      )
                    : FilledButton.icon(
                        style: FilledButton.styleFrom(
                          backgroundColor: FlipColors.yellow,
                          foregroundColor: Colors.black,
                          shape: shape,
                        ),
                        onPressed: onPressed,
                        icon: const Icon(Icons.add_shopping_cart),
                        label: const Text('Add to Cart', style: labelStyle),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
