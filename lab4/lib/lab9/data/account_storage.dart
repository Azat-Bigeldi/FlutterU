import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Локальные аккаунты на устройстве (учебная замена серверу).
/// Пароль не хранится открытым текстом: только соль и хеш.
class AccountStorage {
  static const String accountsKey = 'registered_accounts_json';

  Future<Map<String, dynamic>> _readAll(SharedPreferences preferences) async {
    final savedJson = preferences.getString(accountsKey);
    if (savedJson == null) return {};

    try {
      return Map<String, dynamic>.from(jsonDecode(savedJson) as Map);
    } on FormatException {
      return {};
    } on TypeError {
      return {};
    }
  }

  String _hash(String password, String salt) =>
      sha256.convert(utf8.encode('$salt:$password')).toString();

  Future<bool> exists(String email) async {
    final preferences = await SharedPreferences.getInstance();
    return (await _readAll(preferences)).containsKey(email);
  }

  Future<void> save({
    required String name,
    required String email,
    required String password,
  }) async {
    final preferences = await SharedPreferences.getInstance();
    final accounts = await _readAll(preferences);
    final random = Random.secure();
    final salt = base64Encode(List.generate(16, (_) => random.nextInt(256)));

    accounts[email] = {
      'name': name,
      'salt': salt,
      'hash': _hash(password, salt),
    };
    await preferences.setString(accountsKey, jsonEncode(accounts));
  }

  /// Возвращает имя пользователя, если email и пароль подходят, иначе null.
  Future<String?> findName(String email, String password) async {
    final preferences = await SharedPreferences.getInstance();
    final account = (await _readAll(preferences))[email];
    if (account is! Map) return null;
    if (_hash(password, '${account['salt']}') != account['hash']) return null;
    return account['name'] as String?;
  }
}
