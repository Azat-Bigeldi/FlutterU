import 'package:flutter/material.dart';

import '../theme.dart';

/// Картинка товара из сети с заглушкой, если нет интернета.
class ProductImage extends StatelessWidget {
  final String url;
  final BoxFit fit;

  const ProductImage({super.key, required this.url, this.fit = BoxFit.contain});

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      fit: fit,
      loadingBuilder: (context, child, progress) => progress == null
          ? child
          : const Center(child: CircularProgressIndicator(strokeWidth: 2)),
      errorBuilder: (context, error, stack) => Container(
        color: FlipColors.blue.withOpacity(0.1),
        alignment: Alignment.center,
        child: const Icon(Icons.menu_book, size: 48, color: FlipColors.blue),
      ),
    );
  }
}
