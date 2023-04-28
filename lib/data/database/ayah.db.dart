import 'package:quran/data/database/database.dart';
import 'package:quran/data/model/ayah.mdl.dart';
import 'package:sqflite/sqflite.dart';

class AyahDb {
  static const String _table = 'ayah';

  static Future<int> insertAyah(AyahMdl ayah) async {
    final db = await DatabaseSingleton.instance();
    return await db.insert(
      _table,
      ayah.toJson(true),
      conflictAlgorithm: ConflictAlgorithm.abort
    );
  }

  static Future<List<AyahMdl>> getAyah(int surahId, int startAyah, int limitAyah) async {
    int endAyah = startAyah + limitAyah;
    final db = await DatabaseSingleton.instance();
    List<Map<String, dynamic>> array = await db.query(
      _table,
      where: 'surah_id = $surahId AND ayah > $startAyah AND ayah <= $endAyah'
    );

    if (array.isEmpty) {
      return [];
    }

    List<AyahMdl> list = [];
    for (var json in array) {
      list.add(AyahMdl.fromJson(json));
    }

    return list;
  }

  static Future<AyahMdl?> getAyahByNumber(int surahId, int ayahNumber) async {
    final db = await DatabaseSingleton.instance();
    List<Map<String, dynamic>> array = await db.query(
        _table,
        where: 'surah_id = $surahId AND ayah = $ayahNumber'
    );

    if (array.isEmpty) {
      return null;
    }

    return AyahMdl.fromJson(array.first);
  }
}