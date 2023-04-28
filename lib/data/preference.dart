import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

class Preference {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  final String _keyDefault = 'XBynzebdTa';
  final String _keyDatabase = 'TnG5RfBo8k';

  Future<String> _getRandomKey() async {
    final SharedPreferences prefs = await _prefs;
    String? random = prefs.getString(_keyDefault);
    if (random != null) {
      return random;
    }

    random = _generateRandom(null);
    await prefs.setString(_keyDefault, random);
    return random;
  }

  String _generateRandom(int? length) {
    const chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random rnd = Random();
    int stringLength = 10;
    if (length != null && length > 0) {
      stringLength = length;
    }
    var iterable = Iterable.generate(stringLength, (_) => chars.codeUnitAt(rnd.nextInt(chars.length)));
    return String.fromCharCodes(iterable);
  }

  Future<String> getDatabaseName() async {
    const String extension = '.db';
    String? result = await _getString(_keyDatabase);
    if (result != null) {
      return '$result$extension';
    }

    result = _generateRandom(32);
    await _setString(_keyDatabase, result);
    return '$result$extension';
  }

  Future<void> _setString(String key, String value) async {
    final SharedPreferences prefs = await _prefs;
    String random = await _getRandomKey();
    await prefs.setString('$key$random', value);
    return;
  }

  Future<String?> _getString(String key) async {
    final SharedPreferences prefs = await _prefs;
    String random = await _getRandomKey();
    return prefs.getString('$key$random');
  }
}