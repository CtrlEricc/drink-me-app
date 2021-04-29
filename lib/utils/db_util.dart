import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

// Salva os dados em SQL
class DbUtil {
  static Future<sql.Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(
      path.join(dbPath, 'data.db'),
      onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE dailydata (date TEXT PRIMARY KEY, currentLDay REAL, goalFinished INTEGER)');
      },
      version: 1,
    );
  }

  // Método que adiciona novos registros
  static Future<void> insert(String table, Map<String, dynamic> data) async {
    final db = await DbUtil.database();
    await db.insert(
      table,
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  // Método para carrregar dados do BD
  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await DbUtil.database();
    return db.query(table);
  }
}
