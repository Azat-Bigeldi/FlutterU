import 'package:flutter/material.dart';

/// Компактный рейтинг: ★ 4.8
class RatingStars extends StatelessWidget {
  final double rating;
  final double size;

  const RatingStars({super.key, required this.rating, this.size = 15});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.star_rounded, size: size, color: const Color(0xFFFFB300)),
        const SizedBox(width: 2),
        Text(
          rating.toStringAsFixed(1),
          style: TextStyle(fontSize: size * 0.8, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
