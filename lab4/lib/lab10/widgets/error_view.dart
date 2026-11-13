import 'package:flutter/material.dart';

import '../theme.dart';

class ErrorView extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onRetry;

  const ErrorView({
    super.key,
    required this.title,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off_rounded, size: 96, color: FlipColors.grey),
            const SizedBox(height: 16),
            Text(title,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text(message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: FlipColors.grey, fontSize: 15)),
            const SizedBox(height: 24),
            SizedBox(
              height: 50,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: FlipColors.yellow,
                  foregroundColor: Colors.black,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                ),
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry Connection',
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
