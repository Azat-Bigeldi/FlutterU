import 'package:flutter/material.dart';

class FlipColors {
  static const blue = Color(0xFF1E6FE0);
  static const yellow = Color(0xFFFFC107);
  static const red = Color(0xFFE53935);
  static const background = Color(0xFFF4F4F5);
  static const card = Colors.white;
  static const grey = Color(0xFF8E8E93);
}

String formatPrice(double price) => '\$${price.toStringAsFixed(2)}';
