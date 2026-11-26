import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/local_storage_service.dart';
import 'models/note_item.dart';
import 'providers/cart_provider.dart';
import 'screens/root_screen.dart';
import 'theme.dart';

Future<void> main() async {
  // Load local settings before runApp to avoid a light-theme flash on launch.
  WidgetsFlutterBinding.ensureInitialized();
  final preferences = await SharedPreferences.getInstance();

  final initialDarkMode = LocalStorageService.readDarkMode(preferences);
  final initialDisplayName = LocalStorageService.readDisplayName(preferences);
  final initialNotes = LocalStorageService.readNotes(preferences);

  runApp(
    ChangeNotifierProvider(
      create: (_) => CartProvider(),
      child: FlipApp(
        initialDarkMode: initialDarkMode,
        initialDisplayName: initialDisplayName,
        initialNotes: initialNotes,
      ),
    ),
  );
}

class FlipApp extends StatefulWidget {
  final bool initialDarkMode;
  final String initialDisplayName;
  final List<NoteItem> initialNotes;

  const FlipApp({
    super.key,
    required this.initialDarkMode,
    required this.initialDisplayName,
    required this.initialNotes,
  });

  @override
  State<FlipApp> createState() => _FlipAppState();
}

class _FlipAppState extends State<FlipApp> {
  late bool _isDarkMode;
  late String _displayName;
  late List<NoteItem> _notes;

  @override
  void initState() {
    super.initState();
    _isDarkMode = widget.initialDarkMode;
    _displayName = widget.initialDisplayName;
    _notes = List<NoteItem>.of(widget.initialNotes);
  }

  Future<void> _updateTheme(bool value) async {
    setState(() => _isDarkMode = value);
    await LocalStorageService.saveDarkMode(value);
  }

  Future<void> _updateDisplayName(String value) async {
    final cleanedName = value.trim().isEmpty ? 'Guest User' : value.trim();
    setState(() => _displayName = cleanedName);
    await LocalStorageService.saveDisplayName(cleanedName);
  }

  Future<void> _updateNotes(List<NoteItem> value) async {
    final updatedNotes = List<NoteItem>.of(value);
    setState(() => _notes = updatedNotes);
    await LocalStorageService.saveNotes(updatedNotes);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flip',
      debugShowCheckedModeBanner: false,
      theme: buildFlipTheme(Brightness.light),
      darkTheme: buildFlipTheme(Brightness.dark),
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: RootScreen(
        isDarkMode: _isDarkMode,
        displayName: _displayName,
        notes: _notes,
        onThemeChanged: _updateTheme,
        onDisplayNameSaved: _updateDisplayName,
        onNotesChanged: _updateNotes,
      ),
    );
  }
}
