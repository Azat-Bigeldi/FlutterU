import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/journal_entry.dart';

class JournalStorage {
  static const String entriesKey = 'photo_journal_json';

  Future<List<JournalEntry>> read() async {
    final preferences = await SharedPreferences.getInstance();
    final savedJson = preferences.getString(entriesKey);
    if (savedJson == null) return [];

    try {
      return (jsonDecode(savedJson) as List<dynamic>)
          .map(
            (e) => JournalEntry.fromJson(Map<String, dynamic>.from(e as Map)),
          )
          .toList();
    } on FormatException {
      return [];
    } on TypeError {
      return [];
    }
  }

  Future<void> write(List<JournalEntry> entries) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(
      entriesKey,
      jsonEncode(entries.map((e) => e.toJson()).toList()),
    );
  }
}
