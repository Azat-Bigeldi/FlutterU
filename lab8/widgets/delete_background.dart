import 'package:flutter/material.dart';

import '../theme.dart';

/// Красный фон, который открывается при свайпе справа налево.
class DeleteBackground extends StatelessWidget {
  final BorderRadius borderRadius;

  const DeleteBackground({super.key, this.borderRadius = BorderRadius.zero});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: FlipColors.red,
        borderRadius: borderRadius,
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Удалить',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          SizedBox(width: 8),
          Icon(Icons.delete, color: Colors.white),
        ],
      ),
    );
  }
}
