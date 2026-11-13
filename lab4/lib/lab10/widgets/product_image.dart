import 'package:flutter/material.dart';

import '../theme.dart';

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
      errorBuilder: (context, error, stack) => const Center(
        child: Icon(Icons.image_not_supported_outlined,
            size: 32, color: FlipColors.grey),
      ),
    );
  }
}
