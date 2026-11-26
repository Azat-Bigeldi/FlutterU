import 'package:flutter/material.dart';

/// Цвета в стиле приложения Flip.kz
class FlipColors {
  static const blue = Color(0xFF1E6FE0);
  static const yellow = Color(0xFFFFC107);
  static const red = Color(0xFFE53935);
  static const background = Color(0xFFF4F4F5);
  static const card = Colors.white;
  static const grey = Color(0xFF8E8E93);
}

/// 3042 -> "3 042 ₸"
String formatPrice(int price) {
  final s = price.toString();
  final buf = StringBuffer();
  for (int i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) buf.write(' ');
    buf.write(s[i]);
  }
  return '${buf.toString()} ₸';
}
