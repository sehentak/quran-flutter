import 'package:quran/data/preference.dart';
import 'package:quran/internal/gen/default.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseSingleton {
  late Database db;

  static final DatabaseSingleton _singleton = DatabaseSingleton._internal();
  factory DatabaseSingleton() => _singleton;

  DatabaseSingleton._internal();

  static Future<Database> instance() async {
    Preference pref = Preference();
    String dbName = await pref.getDatabaseName();
    String databasesPath = await getDatabasesPath();
    databasesPath = "$databasesPath/$dbName";
    _singleton.db = await openDatabase(
      databasesPath,
      version: Default.dbVersion,
      onCreate: (db, version) async {
        List<String> sqlToExecute = Default.sqlToExecute;
        if (sqlToExecute.isNotEmpty) {
          for (var sql in sqlToExecute) {
            await db.execute(sql);
          }
        }
      }
    );
    return _singleton.db;
  }
}