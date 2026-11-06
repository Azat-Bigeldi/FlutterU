import 'package:flutter/material.dart';

import '../theme.dart';

/// Заглушка, когда все товары удалены свайпом.
class EmptyState extends StatelessWidget {
  final VoidCallback onReset;

  const EmptyState({super.key, required this.onReset});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.inventory_2_outlined, size: 96, color: FlipColors.grey),
            const SizedBox(height: 16),
            const Text('Catalog is Empty',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            const Text(
              'Все товары удалены.\nВерните исходный каталог, чтобы продолжить.',
              textAlign: TextAlign.center,
              style: TextStyle(color: FlipColors.grey, fontSize: 15),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 50,
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: FlipColors.yellow,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                ),
                onPressed: onReset,
                icon: const Icon(Icons.restart_alt),
                label: const Text('Reset Catalog',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
