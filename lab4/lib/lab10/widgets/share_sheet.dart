import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/product.dart';
import '../theme.dart';

void showShareSheet(BuildContext context, Product product) {
  showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    backgroundColor: Colors.white,
    builder: (_) => _ShareSheet(product: product),
  );
}

class _ShareSheet extends StatelessWidget {
  final Product product;

  const _ShareSheet({required this.product});

  Future<void> _copy(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: product.deepLink));
    if (!context.mounted) return;

    final messenger = ScaffoldMessenger.of(context);
    Navigator.pop(context);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('Ссылка скопирована'),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Поделиться товаром',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            Text(product.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: FlipColors.grey)),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.only(left: 14),
              decoration: BoxDecoration(
                color: FlipColors.background,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.link, color: FlipColors.blue),
                  const SizedBox(width: 10),
                  Expanded(
                    child: SelectableText(
                      product.deepLink,
                      maxLines: 1,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Скопировать',
                    icon: const Icon(Icons.copy_rounded),
                    onPressed: () => _copy(context),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 50,
              width: double.infinity,
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: FlipColors.blue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                ),
                onPressed: () => _copy(context),
                icon: const Icon(Icons.copy_rounded, size: 20),
                label: const Text('Copy Link',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
