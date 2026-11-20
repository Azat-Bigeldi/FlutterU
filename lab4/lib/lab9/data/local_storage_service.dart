import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/note_item.dart';

class LocalStorageService {
  static const String themeKey = 'app_theme_dark_mode';
  static const String displayNameKey = 'user_display_name';
  static const String notesKey = 'saved_notes_json';

  static bool readDarkMode(SharedPreferences preferences) {
    return preferences.getBool(themeKey) ?? false;
  }

  static String readDisplayName(SharedPreferences preferences) {
    return preferences.getString(displayNameKey) ?? 'Guest User';
  }

  static List<NoteItem> readNotes(SharedPreferences preferences) {
    final savedJson = preferences.getString(notesKey);
    if (savedJson == null || savedJson.isEmpty) return [];

    try {
      final decoded = jsonDecode(savedJson) as List<dynamic>;
      return decoded
          .map(
            (item) => NoteItem.fromJson(Map<String, dynamic>.from(item as Map)),
          )
          .toList();
    } on FormatException {
      return [];
    } on TypeError {
      return [];
    }
  }

  static Future<void> saveDarkMode(bool value) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(themeKey, value);
  }

  static Future<void> saveDisplayName(String value) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(displayNameKey, value);
  }

  static Future<void> saveNotes(List<NoteItem> notes) async {
    final preferences = await SharedPreferences.getInstance();
    final notesJson = jsonEncode(notes.map((note) => note.toJson()).toList());
    await preferences.setString(notesKey, notesJson);
  }
}
