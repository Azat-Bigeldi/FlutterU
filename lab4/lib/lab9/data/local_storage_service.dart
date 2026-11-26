import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/location_fix.dart';
import '../models/note_item.dart';

class LocalStorageService {
  static const String themeKey = 'app_theme_dark_mode';
  static const String displayNameKey = 'user_display_name';
  static const String notesKey = 'saved_notes_json';
  static const String avatarKey = 'profile_avatar_name';
  static const String deliveryPointKey = 'delivery_point_json';

  static String? readAvatarName(SharedPreferences preferences) {
    return preferences.getString(avatarKey);
  }

  static LocationFix? readDeliveryPoint(SharedPreferences preferences) {
    final savedJson = preferences.getString(deliveryPointKey);
    if (savedJson == null) return null;

    try {
      return LocationFix.fromJson(
        Map<String, dynamic>.from(jsonDecode(savedJson) as Map),
      );
    } on FormatException {
      return null;
    } on TypeError {
      return null;
    }
  }

  static Future<void> saveAvatarName(String? name) async {
    final preferences = await SharedPreferences.getInstance();
    if (name == null) {
      await preferences.remove(avatarKey);
    } else {
      await preferences.setString(avatarKey, name);
    }
  }

  static Future<void> saveDeliveryPoint(LocationFix point) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(deliveryPointKey, jsonEncode(point.toJson()));
  }

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
