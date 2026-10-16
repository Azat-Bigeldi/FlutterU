import 'package:flutter/material.dart';

import 'screens/root_screen.dart';
import 'theme.dart';

void main() {
  runApp(const FlipApp());
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
