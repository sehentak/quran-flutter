import 'package:quran/data/database/database.dart';
import 'package:quran/data/model/tafsir.mdl.dart';
import 'package:sqflite/sqflite.dart';

class TafsirDb {
  static const String _table = 'tafsir';

  static Future<int> insertTafsir(int ayahId, TafsirMdl tafsir) async {
    final db = await DatabaseSingleton.instance();
    return await db.insert(
      _table,
      tafsir.toJson(ayahId),
      conflictAlgorithm: ConflictAlgorithm.abort
    );
  }

  static Future<TafsirMdl?> getTafsir(int ayahId) async {
    final db = await DatabaseSingleton.instance();
    List<Map<String, dynamic>> list = await db.query(
      _table,
      where: 'ayah_id = $ayahId'
    );

    if (list.isEmpty) {
      return null;
    }

    return TafsirMdl.fromJson(list.first);
  }
}