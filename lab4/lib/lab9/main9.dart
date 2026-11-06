import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/cart_provider.dart';
import 'screens/root_screen.dart';
import 'theme.dart';

void main() {
  runApp(
    // LW9: MaterialApp обёрнут в ChangeNotifierProvider.
    // Провайдер стоит ВЫШЕ Navigator (он внутри MaterialApp), поэтому
    // CartProvider виден на всех экранах, в том числе после Navigator.push.
    ChangeNotifierProvider(
      create: (_) => CartProvider(),
      child: const FlipApp(),
    ),
  );
}

class FlipApp extends StatelessWidget {
  const FlipApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flip',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: FlipColors.blue,
        scaffoldBackgroundColor: FlipColors.background,
        appBarTheme: const AppBarTheme(
          backgroundColor: FlipColors.background,
          surfaceTintColor: Colors.transparent,
          centerTitle: true,
        ),
      ),
      home: const RootScreen(),
    );
  }
}
