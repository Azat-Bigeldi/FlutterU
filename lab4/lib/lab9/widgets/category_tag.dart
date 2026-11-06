import 'package:flutter/material.dart';

import '../theme.dart';

/// Маленький тег категории.
class CategoryTag extends StatelessWidget {
  final String label;

  const CategoryTag({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: FlipColors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
            fontSize: 11, color: FlipColors.blue, fontWeight: FontWeight.w600),
      ),
    );
  }
}
