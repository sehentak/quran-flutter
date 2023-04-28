import 'package:quran/data/database/database.dart';
import 'package:quran/data/model/surah.mdl.dart';
import 'package:sqflite/sqflite.dart';

class SurahDb {
  static const String _table = 'surah';

  static Future<int> insertSurah(SurahMdl surah) async {
    final db = await DatabaseSingleton.instance();
    return await db.insert(
      _table,
      surah.toJson(true),
      conflictAlgorithm: ConflictAlgorithm.abort
    );
  }

  static Future<List<SurahMdl>> getSurah() async {
    final db = await DatabaseSingleton.instance();
    List<Map<String, dynamic>> array = await db.query(_table);
    if (array.isEmpty) {
      return [];
    }

    List<SurahMdl> list = [];
    for (var json in array) {
      list.add(SurahMdl.fromJson(json));
    }
    return list;
  }

  static Future<SurahMdl?> getSurahById(int surahId) async {
    final db = await DatabaseSingleton.instance();
    List<Map<String, dynamic>> array = await db.query(
      _table,
      where: 'id = $surahId'
    );

    if (array.isEmpty) {
      return null;
    }

    SurahMdl surah = SurahMdl.fromJson(array.first);
    return surah;
  }
}